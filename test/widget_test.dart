import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('profile image is bundled as a readable asset', () async {
    final image = await rootBundle.load('images/profile.png');

    expect(image.lengthInBytes, greaterThan(0));
  });

  testWidgets('drawer displays the profile image asset',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'connecte': true});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    final profile = tester.widget<Image>(
      find.byKey(const ValueKey('drawer-profile-image')),
    );
    expect((profile.image as AssetImage).assetName, 'images/profile.png');
    expect(tester.takeException(), isNull);
  });

  testWidgets('new user starts on the inscription page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Créer un compte'), findsOneWidget);
  });

  testWidgets('registration saves credentials and opens home',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'alice');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');
    await tester.tap(find.text('Inscription'));
    await tester.pumpAndSettle();

    expect(find.text('Page Home (Accueil)'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('login'), 'alice');
    expect(prefs.getString('password'), 'secret');
    expect(prefs.getBool('connecte'), isTrue);
  });

  testWidgets('empty registration displays an error',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inscription'));
    await tester.pump();

    expect(
      find.text('Veuillez saisir l’identifiant et le mot de passe.'),
      findsOneWidget,
    );
  });

  testWidgets('valid authentication opens home',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'login': 'alice',
      'password': 'secret',
      'connecte': false,
    });
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text("J'ai déjà un compte"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'alice');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');
    await tester.tap(find.text('Connexion'));
    await tester.pumpAndSettle();

    expect(find.text('Page Home (Accueil)'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('connecte'), isTrue);
  });

  testWidgets('invalid authentication displays an error',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'login': 'alice',
      'password': 'secret',
    });
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text("J'ai déjà un compte"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'alice');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong');
    await tester.tap(find.text('Connexion'));
    await tester.pump();

    expect(find.text('Identifiant ou mot de passe incorrect.'), findsOneWidget);
  });

  testWidgets('connected user starts on home and can log out',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'connecte': true});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Page Home (Accueil)'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Déconnexion'));
    await tester.pumpAndSettle();

    expect(find.text('Page Authentification'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('connecte'), isFalse);
  });

  testWidgets('home drawer navigates to the weather page',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'connecte': true});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Météo'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(Center, 'Page Météo'), findsOneWidget);
  });
}
