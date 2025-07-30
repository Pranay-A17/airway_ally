import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/features/onboarding/onboarding_screen.dart';
import 'package:airway_ally/features/onboarding/role_selection_screen.dart';
import 'package:airway_ally/features/onboarding/seeker_onboarding_screen.dart';
import 'package:airway_ally/features/onboarding/navigator_onboarding_screen.dart';

void main() {
  group('Onboarding Tests', () {
    testWidgets('OnboardingScreen displays welcome content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify onboarding elements are present
      expect(find.text('Welcome to Airway Ally'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('Onboarding navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap get started button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
    });

    testWidgets('RoleSelectionScreen displays role options', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify role options are present
      expect(find.text('Choose Your Role'), findsOneWidget);
      expect(find.text('Seeker'), findsOneWidget);
      expect(find.text('Navigator'), findsOneWidget);
    });

    testWidgets('Seeker role selection works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap seeker option
      await tester.tap(find.text('Seeker'));
      await tester.pumpAndSettle();
    });

    testWidgets('Navigator role selection works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap navigator option
      await tester.tap(find.text('Navigator'));
      await tester.pumpAndSettle();
    });

    testWidgets('SeekerOnboardingScreen displays form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SeekerOnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify form elements are present
      expect(find.text('Seeker Profile'), findsOneWidget);
      expect(find.text('Tell us about yourself'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
    });

    testWidgets('Seeker form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SeekerOnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Complete Profile'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('NavigatorOnboardingScreen displays form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NavigatorOnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify form elements are present
      expect(find.text('Navigator Profile'), findsOneWidget);
      expect(find.text('Tell us about your expertise'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
    });

    testWidgets('Navigator form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NavigatorOnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Complete Profile'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Language selection in seeker onboarding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SeekerOnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify language options are present
      expect(find.text('Languages you speak:'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
    });

    testWidgets('Assistance needs selection in seeker onboarding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SeekerOnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify assistance options are present
      expect(find.text('What assistance do you need?'), findsOneWidget);
      expect(find.text('Immigration Process'), findsOneWidget);
      expect(find.text('Customs Declaration'), findsOneWidget);
    });

    testWidgets('Expertise selection in navigator onboarding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NavigatorOnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify expertise options are present
      expect(find.text('Areas of expertise:'), findsOneWidget);
      expect(find.text('Immigration Process'), findsOneWidget);
      expect(find.text('Customs Declaration'), findsOneWidget);
    });
  });
} 