import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  Set<String> _favoriteShopNames = {};
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? saved = _prefs?.getStringList('favorite_shops');
    if (saved != null) {
      _favoriteShopNames = saved.toSet();
    }
    notifyListeners();
  }

  bool isFavorite(String shopName) => _favoriteShopNames.contains(shopName);

  Future<void> toggleFavorite(String shopName) async {
    if (_favoriteShopNames.contains(shopName)) {
      _favoriteShopNames.remove(shopName);
    } else {
      _favoriteShopNames.add(shopName);
    }
    await _prefs?.setStringList('favorite_shops', _favoriteShopNames.toList());
    notifyListeners();
  }

  List<String> get favoriteShopNames => _favoriteShopNames.toList();
}
