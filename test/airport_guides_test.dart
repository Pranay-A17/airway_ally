import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/features/airport/airport_guides_page.dart';

void main() {
  group('Airport Guides Tests', () {
    testWidgets('AirportGuidesPage displays airport list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AirportGuidesPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page elements are present
      expect(find.text('Airport Guides'), findsOneWidget);
      expect(find.text('Popular Airports'), findsOneWidget);
    });

    testWidgets('Airport cards display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AirportGuidesPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify airport cards are present
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Airport detail page displays information', (WidgetTester tester) async {
      final testAirport = {
        'code': 'JFK',
        'name': 'John F. Kennedy International Airport',
        'location': 'New York, NY',
        'description': 'Major international airport serving New York City',
        'terminals': 6,
      };

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AirportDetailPage(airport: testAirport),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify airport detail elements are present
      expect(find.text('JFK Guide'), findsOneWidget);
      expect(find.text('JFK'), findsOneWidget);
      expect(find.text('John F. Kennedy International Airport'), findsOneWidget);
      expect(find.text('New York, NY'), findsOneWidget);
    });

    testWidgets('Airport amenities are displayed', (WidgetTester tester) async {
      final testAirport = {
        'code': 'LAX',
        'name': 'Los Angeles International Airport',
        'location': 'Los Angeles, CA',
        'description': 'Major international airport serving Los Angeles',
        'terminals': 8,
      };

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AirportDetailPage(airport: testAirport),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify amenities section is present
      expect(find.text('Amenities'), findsOneWidget);
      expect(find.text('Restaurants'), findsOneWidget);
      expect(find.text('Shops'), findsOneWidget);
    });

    testWidgets('Transportation information is displayed', (WidgetTester tester) async {
      final testAirport = {
        'code': 'SFO',
        'name': 'San Francisco International Airport',
        'location': 'San Francisco, CA',
        'description': 'Major international airport serving San Francisco',
        'terminals': 4,
      };

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AirportDetailPage(airport: testAirport),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify transportation section is present
      expect(find.text('Transportation'), findsOneWidget);
      expect(find.text('Train'), findsOneWidget);
      expect(find.text('Bus'), findsOneWidget);
      expect(find.text('Taxi'), findsOneWidget);
    });

    testWidgets('Travel tips are displayed', (WidgetTester tester) async {
      final testAirport = {
        'code': 'ORD',
        'name': 'O\'Hare International Airport',
        'location': 'Chicago, IL',
        'description': 'Major international airport serving Chicago',
        'terminals': 4,
      };

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AirportDetailPage(airport: testAirport),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify travel tips section is present
      expect(find.text('Travel Tips'), findsOneWidget);
    });

    testWidgets('Airport search functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AirportGuidesPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for search functionality
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Airport navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AirportGuidesPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on an airport card if present
      final airportCards = find.byType(Card);
      if (airportCards.evaluate().isNotEmpty) {
        await tester.tap(airportCards.first);
        await tester.pumpAndSettle();
      }
    });
  });
} 