import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'data/user_store.dart';
import 'data/favorites_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database/Persistence
  final userStore = UserStore();
  final favoritesManager = FavoritesManager();
  
  await userStore.init();
  await favoritesManager.init();

  runApp(const BarberHubApp());
}

class BarberHubApp extends StatelessWidget {
  const BarberHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = UserStore();
    
    return MaterialApp(
      title: 'BARBERUNPAS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Jika user sudah login sebelumnya, langsung ke Home
      home: userStore.currentUser != null 
          ? const MainNavigation() 
          : const LoginScreen(),
    );
  }
}
