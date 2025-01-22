import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';

void main() {
  // Show loading screen immediately
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );

  // Initialize the app
  initializeApp();
}

Future<void> initializeApp() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('Initializing app...');
    
    final prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized');
    
    final storageService = StorageService(prefs: prefs);
    print('StorageService initialized');

    // Run the actual app
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(storageService: storageService),
          ),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error initializing app: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareSathi',
      theme: ThemeData(
        primaryColor: const Color(0xFF07569b),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF07569b)),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          print('Auth state: ${auth.isInitializing}');
          if (auth.isInitializing) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
