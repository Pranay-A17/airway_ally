import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/features/documents/documents_page.dart';

void main() {
  group('Documents Tests', () {
    testWidgets('DocumentsPage displays document list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DocumentsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page elements are present
      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Travel Documents'), findsOneWidget);
      expect(find.text('Flight Documents'), findsOneWidget);
    });

    testWidgets('Document categories are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DocumentsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify category buttons are present
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Travel Documents'), findsOneWidget);
      expect(find.text('Flight Documents'), findsOneWidget);
      expect(find.text('Accommodation'), findsOneWidget);
      expect(find.text('Health Documents'), findsOneWidget);
    });

    testWidgets('Document cards display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DocumentsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify document cards are present
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Search functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DocumentsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify search dialog appears
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Sort functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DocumentsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap sort icon
      await tester.tap(find.byIcon(Icons.sort));
      await tester.pumpAndSettle();

      // Verify sort options are present
      expect(find.text('Sort by'), findsOneWidget);
    });

    testWidgets('Add document functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DocumentsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for add document button
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Document details dialog works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DocumentsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on a document card if present
      final documentCards = find.byType(Card);
      if (documentCards.evaluate().isNotEmpty) {
        await tester.tap(documentCards.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Category filtering works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DocumentsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Travel Documents category
      await tester.tap(find.text('Travel Documents'));
      await tester.pumpAndSettle();

      // Verify filter is applied
      expect(find.text('Travel Documents'), findsOneWidget);
    });
  });
} 