// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/main.dart';

void main() {
  group('Airway Ally App Tests', () {
    testWidgets('App starts and shows authentication screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the app starts with the auth screen
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('App theme is properly configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify Material 3 theme is used
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App navigation structure is correct', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify basic app structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsWidgets);
    });

    testWidgets('App handles different screen sizes', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify responsive design elements
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('App shows proper loading states', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Enter credentials to trigger loading state
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Should show loading indicator or loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('App form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('App registration flow is accessible', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Switch to registration
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();

      // Verify registration form is shown
      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Role'), findsOneWidget);
    });

    testWidgets('App handles user interactions properly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test text input
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.pump();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('App maintains state during navigation', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Enter some text
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.pump();

      // Navigate to registration and back
      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Already have an account? Sign In'));
      await tester.pumpAndSettle();

      // Text should still be there
      expect(find.text('test@example.com'), findsOneWidget);
    });
  });
}
