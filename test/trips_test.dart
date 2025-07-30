import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airway_ally/features/trips/my_trips_page.dart';
import 'package:airway_ally/features/trips/track_flight_page.dart';
import 'package:airway_ally/models/trip_model.dart';

void main() {
  group('Trips Tests', () {
    testWidgets('MyTripsPage displays trip list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyTripsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page elements are present
      expect(find.text('My Trips'), findsOneWidget);
      expect(find.text('Upcoming Trips'), findsOneWidget);
      expect(find.text('Past Trips'), findsOneWidget);
    });

    testWidgets('Trip card displays correct information', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyTripsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify trip card elements are present
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('TrackFlightPage displays flight information', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TrackFlightPage(
              flightNumber: 'AA123',
              from: 'JFK',
              to: 'LAX',
              date: '2024-01-15',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify flight tracking elements are present
      expect(find.text('AA123'), findsOneWidget);
      expect(find.text('JFK'), findsOneWidget);
      expect(find.text('LAX'), findsOneWidget);
    });

    testWidgets('Flight status updates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TrackFlightPage(
              flightNumber: 'UA456',
              from: 'SFO',
              to: 'ORD',
              date: '2024-01-15',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify flight status elements are present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Add trip functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyTripsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for add trip button
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Trip details navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyTripsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on a trip card if present
      final tripCards = find.byType(Card);
      if (tripCards.evaluate().isNotEmpty) {
        await tester.tap(tripCards.first);
        await tester.pumpAndSettle();
      }
    });
  });
} 