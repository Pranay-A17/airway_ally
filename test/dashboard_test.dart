import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/main_dashboard.dart';
import 'package:airway_ally/models/user_model.dart';

void main() {
  group('Main Dashboard Tests', () {
    testWidgets('Dashboard shows seeker home for seeker role', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboard(),
          ),
        ),
      );

      // Wait for dashboard to load
      await tester.pumpAndSettle();

      // Verify seeker-specific features are present
      expect(find.text('Request Help'), findsOneWidget);
      expect(find.text('My Trips'), findsOneWidget);
      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('Airport Guides'), findsOneWidget);
    });

    testWidgets('Dashboard shows navigator home for navigator role', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboard(),
          ),
        ),
      );

      // Wait for dashboard to load
      await tester.pumpAndSettle();

      // Verify navigator-specific features are present
      expect(find.text('Help Requests'), findsOneWidget);
      expect(find.text('My Trips'), findsOneWidget);
      expect(find.text('Badges & Stats'), findsOneWidget);
      expect(find.text('Documents'), findsOneWidget);
    });

    testWidgets('Bottom navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboard(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify bottom navigation is present
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Profile section shows user info', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboard(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify profile elements are present
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Logout functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboard(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap profile icon
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify logout option is present
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('Navigation to different sections works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainDashboard(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test navigation to different sections
      await tester.tap(find.text('My Trips'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Documents'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Airport Guides'));
      await tester.pumpAndSettle();
    });
  });
} 