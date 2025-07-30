import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/features/auth/auth_screen.dart';
import 'package:airway_ally/providers/auth_provider.dart';

void main() {
  group('Authentication Tests', () {
    testWidgets('AuthScreen displays login form by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Verify login form elements are present
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text("Don't have an account? Register"), findsOneWidget);
      expect(find.text('Sign In'), findsNWidgets(2)); // One in AppBar, one in button
    });

    testWidgets('AuthScreen switches to registration form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Tap the register link
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pump();

      // Verify registration form elements are present
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Role'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Already have an account? Sign In'), findsOneWidget);
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Try to submit empty form
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Registration form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Switch to registration
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pump();

      // Try to submit empty form
      await tester.tap(find.text('Register'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Email validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Password validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Enter short password
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show password validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('Role selection works in registration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Switch to registration
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pump();

      // Verify role dropdown is present
      expect(find.text('Seeker'), findsOneWidget);
      expect(find.text('Navigator'), findsOneWidget);
    });

    testWidgets('Password confirmation validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Switch to registration
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pump();

      // Enter different passwords
      final passwordFields = find.byType(TextFormField);
      await tester.enterText(passwordFields.at(2), 'password123');
      await tester.enterText(passwordFields.at(3), 'password456');
      await tester.tap(find.text('Register'));
      await tester.pump();

      // Should show password mismatch error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Loading state shows during authentication', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AuthScreen(),
          ),
        ),
      );

      // Enter valid credentials
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap sign in
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
} 