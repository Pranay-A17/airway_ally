import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:airway_ally/features/auth/auth_screen.dart';
import 'test_config.dart';

void main() {
  group('Core Functionality Tests', () {
    testWidgets('App starts and shows authentication screen', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Verify basic auth screen elements
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Find the sign in button (more specific)
      final signInButtons = find.widgetWithText(ElevatedButton, 'Sign In');
      expect(signInButtons, findsOneWidget);

      // Tap the sign in button
      await tester.tap(signInButtons.first);
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Registration form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Switch to registration
      final registerLink = find.text("Don't have an account? Register");
      expect(registerLink, findsOneWidget);
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      // Find the register button
      final registerButtons = find.widgetWithText(ElevatedButton, 'Register');
      expect(registerButtons, findsOneWidget);

      // Tap register button
      await tester.tap(registerButtons.first);
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Email validation works', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      
      // Tap sign in
      final signInButtons = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.tap(signInButtons.first);
      await tester.pump();

      // Should show email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Password validation works', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Enter short password
      final passwordFields = find.byType(TextFormField);
      await tester.enterText(passwordFields.last, '123');
      
      // Tap sign in
      final signInButtons = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.tap(signInButtons.first);
      await tester.pump();

      // Should show password validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('Form switching works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Initially should be in login mode
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsNothing);

      // Switch to registration
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();

      // Should be in registration mode
      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // Switch back to login
      await tester.tap(find.text('Already have an account? Sign In'));
      await tester.pumpAndSettle();

      // Should be back in login mode
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsNothing);
    });

    testWidgets('Text input works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Enter text in email field
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Loading state shows during form submission', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Enter valid credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Tap sign in
      final signInButtons = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.tap(signInButtons.first);
      await tester.pump();

      // Should show loading indicator or loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Alternative: check for loading text or disabled button
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('App theme is properly configured', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Verify Material 3 theme is used
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Responsive design elements are present', (WidgetTester tester) async {
      await tester.pumpWidget(TestConfig.wrapWithProviders(const AuthScreen()));
      await tester.pumpAndSettle();

      // Verify responsive design elements
      expect(find.byType(SafeArea), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
} 