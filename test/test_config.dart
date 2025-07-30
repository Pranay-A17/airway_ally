import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:airway_ally/firebase_options.dart';

class TestConfig {
  static Future<void> setupFirebaseForTesting() async {
    // Initialize Firebase for testing
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Widget wrapWithProviders(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  static Widget wrapWithProvidersAndFirebase(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: FutureBuilder(
          future: setupFirebaseForTesting(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return child;
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
} 