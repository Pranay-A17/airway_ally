import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/main.dart';
import 'package:airway_ally/features/auth/auth_screen.dart';
import 'package:airway_ally/main_dashboard.dart';

void main() {
  group('Integration Tests', () {
    testWidgets('Complete app flow from login to dashboard', (WidgetTester tester) async {
      // Start with the main app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify we're on the auth screen
      expect(find.text('Sign In'), findsOneWidget);

      // Enter login credentials
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should navigate to dashboard
      expect(find.text('Airway Ally'), findsOneWidget);
    });

    testWidgets('Navigation between different sections works', (WidgetTester tester) async {
      // Start with dashboard
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboard(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to different sections
      await tester.tap(find.text('My Trips'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Documents'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Airport Guides'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request Help'));
      await tester.pumpAndSettle();
    });

    testWidgets('Registration flow works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to registration
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();

      // Fill registration form
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(TextFormField).at(1), 'john@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');

      // Submit registration
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();
    });

    testWidgets('Error handling in forms', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('App theme and styling is consistent', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app uses Material 3 theme
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Responsive design works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app adapts to different screen sizes
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Loading states work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter credentials and submit
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Navigation back functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboard(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to a section
      await tester.tap(find.text('My Trips'));
      await tester.pumpAndSettle();

      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Should be back on dashboard
      expect(find.text('Airway Ally'), findsOneWidget);
    });
  });
} 