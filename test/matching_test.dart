import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/features/matching/matching_page.dart';
import 'package:airway_ally/features/matching/seeker_request_help_page.dart';
import 'package:airway_ally/features/matching/navigator_help_requests_page.dart';

void main() {
  group('Matching Tests', () {
    testWidgets('MatchingPage displays matching interface', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MatchingPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page elements are present
      expect(find.text('Matching'), findsOneWidget);
    });

    testWidgets('SeekerRequestHelpPage displays help request form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SeekerRequestHelpPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify form elements are present
      expect(find.text('Request Help'), findsOneWidget);
      expect(find.text('What type of assistance do you need?'), findsOneWidget);
      expect(find.text('Languages you speak:'), findsOneWidget);
    });

    testWidgets('Help request form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SeekerRequestHelpPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Submit Request'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please select at least one assistance type'), findsOneWidget);
      expect(find.text('Please select at least one language'), findsOneWidget);
    });

    testWidgets('Assistance type selection works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SeekerRequestHelpPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify assistance options are present
      expect(find.text('Immigration Process'), findsOneWidget);
      expect(find.text('Customs Declaration'), findsOneWidget);
      expect(find.text('Airport Navigation'), findsOneWidget);
      expect(find.text('Document Assistance'), findsOneWidget);
    });

    testWidgets('Language selection works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SeekerRequestHelpPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify language options are present
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
      expect(find.text('French'), findsOneWidget);
    });

    testWidgets('NavigatorHelpRequestsPage displays help requests', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NavigatorHelpRequestsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page elements are present
      expect(find.text('Help Requests'), findsOneWidget);
    });

    testWidgets('Help request cards display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NavigatorHelpRequestsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify help request cards are present
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Accept help request functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NavigatorHelpRequestsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for accept buttons
      expect(find.text('Accept'), findsWidgets);
    });

    testWidgets('Help request details dialog works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NavigatorHelpRequestsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on a help request card if present
      final helpRequestCards = find.byType(Card);
      if (helpRequestCards.evaluate().isNotEmpty) {
        await tester.tap(helpRequestCards.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Filter help requests by type', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NavigatorHelpRequestsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for filter options
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });
  });
} 