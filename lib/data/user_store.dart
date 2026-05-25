import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  String name;
  String email;
  String? photoUrl;
  final bool isGoogleUser;
  List<String> history;

  UserSession({
    required this.name,
    required this.email,
    this.photoUrl,
    this.isGoogleUser = false,
    this.history = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'isGoogleUser': isGoogleUser,
    'history': history,
  };

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    photoUrl: json['photoUrl'],
    isGoogleUser: json['isGoogleUser'] ?? false,
    history: List<String>.from(json['history'] ?? []),
  );
}

class UserStore extends ChangeNotifier {
  static final UserStore _instance = UserStore._internal();
  factory UserStore() => _instance;
  UserStore._internal();

  UserSession? _currentUser;
  
  // Database permanen (Simulasi Cloud)
  // Key: email, Value: {password, name, photoUrl, history}
  Map<String, dynamic> _users = {
    'admin@email.com': {
      'password': 'admin123', 
      'name': 'Admin Hub', 
      'photoUrl': null, 
      'history': []
    },
  };

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    
    // 1. Load Database User
    try {
      String? usersJson = _prefs?.getString('barber_master_db');
      if (usersJson != null) {
        _users = jsonDecode(usersJson);
      }
    } catch (e) {
      debugPrint('Error loading master db: $e');
    }

    // 2. Load Sesi Login Aktif
    try {
      String? sessionJson = _prefs?.getString('barber_active_session');
      if (sessionJson != null) {
        _currentUser = UserSession.fromJson(jsonDecode(sessionJson));
      }
    } catch (e) {
      debugPrint('Error loading active session: $e');
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  UserSession? get currentUser => _currentUser;
  List<String> get recentlyViewedNames => _currentUser?.history ?? [];

  Future<void> registerUser(String email, String password, String name) async {
    _users[email] = {
      'password': password,
      'name': name,
      'photoUrl': null,
      'history': [],
    };
    await _saveMasterDb();
    notifyListeners();
  }

  Future<bool> validateUser(String email, String password) async {
    if (_users.containsKey(email) && _users[email]['password'] == password) {
      final userData = _users[email];
      _currentUser = UserSession(
        name: userData['name'] ?? email,
        email: email,
        photoUrl: userData['photoUrl'],
        history: List<String>.from(userData['history'] ?? []),
      );
      await _saveActiveSession();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> addToHistory(String shopName) async {
    if (_currentUser == null) return;

    List<String> currentHistory = List.from(_currentUser!.history);
    currentHistory.remove(shopName);
    currentHistory.insert(0, shopName);
    
    if (currentHistory.length > 5) {
      currentHistory = currentHistory.sublist(0, 5);
    }
    
    _currentUser!.history = currentHistory;
    
    // Simpan ke database Master (Permanen per user)
    if (_users.containsKey(_currentUser!.email)) {
      _users[_currentUser!.email]['history'] = currentHistory;
      await _saveMasterDb();
    }
    
    await _saveActiveSession();
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    if (_currentUser != null) {
      if (name != null) _currentUser!.name = name;
      if (photoUrl != null) _currentUser!.photoUrl = photoUrl;
      
      // Update Sesi Aktif
      await _saveActiveSession();
      
      // Update Database Master (Permanen)
      if (_users.containsKey(_currentUser!.email)) {
        if (name != null) _users[_currentUser!.email]['name'] = name;
        if (photoUrl != null) _users[_currentUser!.email]['photoUrl'] = photoUrl;
        await _saveMasterDb();
      }
      
      notifyListeners();
    }
  }

  Future<void> setGoogleUser(String name, String email, String? photoUrl) async {
    // Untuk Google User, kita cek apakah sudah ada di master db
    if (!_users.containsKey(email)) {
      _users[email] = {
        'password': 'google_auth_user',
        'name': name,
        'photoUrl': photoUrl,
        'history': [],
      };
      await _saveMasterDb();
    }

    final userData = _users[email];
    _currentUser = UserSession(
      name: name,
      email: email,
      photoUrl: photoUrl ?? userData['photoUrl'],
      isGoogleUser: true,
      history: List<String>.from(userData['history'] ?? []),
    );
    
    await _saveActiveSession();
    notifyListeners();
  }

  Future<void> _saveActiveSession() async {
    if (_currentUser != null) {
      await _prefs?.setString('barber_active_session', jsonEncode(_currentUser!.toJson()));
    } else {
      await _prefs?.remove('barber_active_session');
    }
  }

  Future<void> _saveMasterDb() async {
    await _prefs?.setString('barber_master_db', jsonEncode(_users));
  }

  bool userExists(String email) {
    return _users.containsKey(email);
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs?.remove('barber_active_session');
    notifyListeners();
  }
}
