import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'features/auth/auth_screen.dart';
import 'services/notification_service.dart';
import 'core/app_theme.dart';
import 'utils/logger.dart';

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
    Logger.info('Starting Airway Ally app...');
    WidgetsFlutterBinding.ensureInitialized();
    
    Logger.info('Initializing Firebase...');
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      Logger.success('Firebase initialized successfully');
    } catch (e) {
      if (e.toString().contains('duplicate-app')) {
        Logger.info('Firebase already initialized, continuing...');
      } else {
        Logger.error('Firebase initialization error', e);
      }
    }
    
    // Initialize notification service with error handling
    try {
      Logger.info('Initializing notification service...');
      await NotificationService().initialize();
      Logger.success('Notification service initialized successfully');
    } catch (e) {
      Logger.warning('Notification service failed to initialize: $e');
    }
    
    Logger.info('Running app...');
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e) {
    Logger.error('Error during app initialization', e);
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
