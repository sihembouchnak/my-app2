import 'package:flutter/material.dart';

import '../menu/drawer.widget.dart';
import 'meteo-details.page.dart';

class MeteoPage extends StatefulWidget {
  const MeteoPage({super.key});

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  final TextEditingController _cityController = TextEditingController();

  void _onGetMeteoDetails(BuildContext context) {
    final ville = _cityController.text.trim();

    if (ville.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir une ville.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MeteoDetailsPage(ville: ville),
      ),
    ).then((_) {
      if (!mounted) return;
      _cityController.clear();
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4ECF1),
        elevation: 0,
        title: const Text(
          'Météo',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EDF1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_city, color: Colors.black54),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          hintText: 'Ville',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7E1E7),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _onGetMeteoDetails(context),
                  child: const Text(
                    'Chercher',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: Text(
                  'Page Météo',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
