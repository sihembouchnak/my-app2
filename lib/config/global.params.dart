import 'package:flutter/material.dart';

class GlobalParams {
  static const List<Map<String, dynamic>> menu = [
    {'title': 'Accueil', 'icon': Icons.home, 'route': '/home'},
    {'title': 'Météo', 'icon': Icons.wb_sunny, 'route': '/meteo'},
    {'title': 'Maps', 'icon': Icons.map, 'route': '/maps'},
    {'title': 'Contacts', 'icon': Icons.contacts, 'route': '/contact'},
    {'title': 'Messenger', 'icon': Icons.message, 'route': '/messenger'},
    {'title': 'ChatBot', 'icon': Icons.smart_toy, 'route': '/chatbot'},
    {'title': 'Paramètres', 'icon': Icons.settings, 'route': '/parametres'},
    {'title': 'Déconnexion', 'icon': Icons.logout, 'route': null},
  ];

  static const List<Map<String, dynamic>> accueil = [
    {
      'title': 'Météo',
      'image': 'images/meteo.png',
      'icon': Icons.wb_sunny,
      'color': Color(0xFF5B9BD5),
      'route': '/meteo',
    },
    {
      'title': 'Maps',
      'image': 'images/maps.png',
      'icon': Icons.map,
      'color': Color(0xFF79D7A2),
      'route': '/maps',
    },
    {
      'title': 'Contacts',
      'image': 'images/contacts.png',
      'icon': Icons.contacts,
      'color': Color(0xFF285E78),
      'route': '/contact',
    },
    {
      'title': 'Messenger',
      'image': 'images/messenger.png',
      'icon': Icons.message,
      'color': Color(0xFFB12BFA),
      'route': '/messenger',
    },
    {
      'title': 'ChatBot',
      'image': 'images/chatbot.png',
      'icon': Icons.smart_toy,
      'color': Color(0xFF47A6B8),
      'route': '/chatbot',
    },
    {
      'title': 'Paramètres',
      'image': 'images/parametres.png',
      'icon': Icons.settings,
      'color': Color(0xFF263238),
      'route': '/parametres',
    },
  ];
}
