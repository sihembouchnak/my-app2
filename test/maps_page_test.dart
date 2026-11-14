import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/maps-details.page.dart';
import 'package:my_app/pages/maps.page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'maps page offers city, coordinate, and current location inputs',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapsPage()));

      expect(find.text('Nom de ville'), findsOneWidget);
      expect(find.text('Latitude'), findsOneWidget);
      expect(find.text('Longitude'), findsOneWidget);
      expect(find.text('Ma position actuelle'), findsOneWidget);
    },
  );

  testWidgets('Maps menu route opens the search form', (tester) async {
    SharedPreferences.setMockInitialValues({'connecte': true});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Maps'));
    await tester.pumpAndSettle();

    expect(find.text('Page Maps'), findsOneWidget);
    expect(find.text('Nom de ville'), findsOneWidget);
    expect(find.text('Ma position actuelle'), findsOneWidget);
  });

  testWidgets('empty search shows a validation message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapsPage()));

    await tester.tap(find.text('Chercher'));
    await tester.pump();

    expect(
      find.text('Saisissez une ville ou des coordonnées valides.'),
      findsOneWidget,
    );
  });

  testWidgets('coordinates display a map and a location marker', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MapsDetailsPage(latitude: '36.8', longitude: '10.18'),
      ),
    );
    await tester.pump();

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byIcon(Icons.location_pin), findsOneWidget);
  });

  testWidgets('city search opens details and reports a geocoding failure', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MapsPage()));

    await tester.enterText(find.byType(TextFormField).first, 'Tunis');
    await tester.tap(find.text('Chercher'));
    await tester.pumpAndSettle();

    expect(find.text('Page Maps Details'), findsOneWidget);
    expect(
      find.text(
        'Le service de recherche de ville est indisponible (HTTP 400).',
      ),
      findsOneWidget,
    );
    expect(find.text('Retour à la recherche'), findsOneWidget);
  });
}
