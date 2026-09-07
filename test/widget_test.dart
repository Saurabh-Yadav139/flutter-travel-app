import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/models/destination.dart';
import 'package:travel_app/screens/destination_detail_screen.dart';

void main() {
  testWidgets('TravelApp loads with 3 tabs and allows navigation', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const TravelApp());
    await tester.pumpAndSettle();

    // 1. Verify app title and 3 bottom navigation destinations exist
    expect(find.text('Travel Planner'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Itinerary'), findsOneWidget);
    expect(find.text('Book Trip'), findsOneWidget);

    // 2. Verify destination cards exist in Explore tab
    expect(find.text('Paris'), findsOneWidget);

    // 3. Switch to Itinerary tab
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();

    expect(find.text('My Trip Itinerary 🗺️'), findsOneWidget);
    expect(find.text('Add Activity'), findsOneWidget);

    // 4. Switch to Book Trip tab
    await tester.tap(find.byIcon(Icons.airplane_ticket_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Trip Booking Form 🎫'), findsOneWidget);
    expect(find.text('Confirm & Book Trip'), findsOneWidget);
  });

  testWidgets('DestinationDetailScreen renders destination details and highlights', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final testDestination = sampleDestinations.first; // Paris

    await tester.pumpWidget(
      MaterialApp(
        home: DestinationDetailScreen(destination: testDestination),
      ),
    );
    await tester.pumpAndSettle();

    // Verify destination details are shown
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('France • Europe'), findsOneWidget);
    expect(find.text('Trip Highlights'), findsOneWidget);
    expect(find.text('Eiffel Tower'), findsOneWidget);
    expect(find.text('Book This Trip'), findsOneWidget);

    // Toggle favorite
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('Booking tab validates inputs and displays confirmation dialog on submit', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const TravelApp());
    await tester.pumpAndSettle();

    // Switch to Book Trip tab
    await tester.tap(find.byIcon(Icons.airplane_ticket_outlined));
    await tester.pumpAndSettle();

    // Fill form
    await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
    await tester.enterText(find.widgetWithText(TextFormField, 'Email Address'), 'john@example.com');
    await tester.pumpAndSettle();

    // Tap Confirm & Book Trip
    await tester.tap(find.text('Confirm & Book Trip'));
    await tester.pumpAndSettle();

    // Check confirmation dialog appeared
    expect(find.text('Booking Confirmed!'), findsOneWidget);
    expect(find.text('Lead Traveler: John Doe'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Check recent bookings list updated
    expect(find.text('My Confirmed Trips'), findsOneWidget);
    expect(find.textContaining('John Doe'), findsOneWidget);
  });
}
