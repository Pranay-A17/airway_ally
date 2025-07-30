import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'features/auth/auth_screen.dart';
import 'services/notification_service.dart';
import 'core/app_theme.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'App is working!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This is a test screen to verify the app is running properly.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  try {
    print('Starting Airway Ally app...');
    WidgetsFlutterBinding.ensureInitialized();
    
    print('Initializing Firebase...');
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    } catch (e) {
      if (e.toString().contains('duplicate-app')) {
        print('Firebase already initialized, continuing...');
      } else {
        print('Firebase initialization error: $e');
      }
    }
    
    // Initialize notification service with error handling
    try {
      print('Initializing notification service...');
      await NotificationService().initialize();
      print('Notification service initialized successfully');
    } catch (e) {
      print('Warning: Notification service failed to initialize: $e');
    }
    
    print('Running app...');
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e) {
    print('Error during app initialization: $e');
    // Still run the app even if there's an error
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Airway Ally',
        theme: AppTheme.lightTheme,
        home: const AuthScreen(),
        debugShowCheckedModeBanner: false, // Remove debug banner for production
      ),
    );
  }
}
