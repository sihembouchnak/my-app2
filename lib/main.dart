import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/authentification.page.dart';
import 'pages/chatbot.page.dart';
import 'pages/contact.page.dart';
import 'pages/home.page.dart';
import 'pages/inscription.page.dart';
import 'pages/maps.page.dart';
import 'pages/messenger.page.dart';
import 'pages/meteo.page.dart';
import 'pages/parametres.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final Map<String, WidgetBuilder> routes = {
    '/home': (context) => const HomePage(),
    '/inscription': (context) => const InscriptionPage(),
    '/authentification': (context) => const AuthentificationPage(),
    '/meteo': (context) => const MeteoPage(),
    '/maps': (context) => const MapsPage(),
    '/contact': (context) => const ContactPage(),
    '/messenger': (context) => const MessengerPage(),
    '/chatbot': (context) => const ChatbotPage(),
    '/parametres': (context) => const ParametresPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      home: const StartupPage(),
    );
  }
}

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  late final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _preferences,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Impossible de charger les préférences : ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isConnected = snapshot.data!.getBool('connecte') ?? false;
        return isConnected ? const HomePage() : const InscriptionPage();
      },
    );
  }
}