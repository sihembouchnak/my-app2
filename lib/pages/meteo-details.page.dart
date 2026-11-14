import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../menu/drawer.widget.dart';

class MeteoDetailsPage extends StatefulWidget {
  const MeteoDetailsPage({required this.ville, super.key});

  final String ville;

  @override
  State<MeteoDetailsPage> createState() => _MeteoDetailsPageState();
}

class _MeteoDetailsPageState extends State<MeteoDetailsPage> {
  Map<String, dynamic>? meteoData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMeteoData(widget.ville);
  }

  Future<void> getMeteoData(String ville) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=${Uri.encodeComponent(ville)}&appid=c109c07bc4df77a88c923e6407aef864';

    try {
      final response = await http.get(Uri.parse(url));

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          meteoData = json.decode(response.body) as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          meteoData = null;
          isLoading = false;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        meteoData = null;
        isLoading = false;
      });
      debugPrint('Erreur météo: $error');
    }
  }

  Widget _weatherBadge(String? main) {
    final weatherKey = (main ?? 'clouds').toString().toLowerCase();
    final symbol = switch (weatherKey) {
      'clear' => '☀️',
      'clouds' => '☁️',
      'rain' || 'drizzle' => '🌧️',
      'thunderstorm' => '⛈️',
      'snow' => '❄️',
      _ => '🌤️',
    };

    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white.withOpacity(0.7),
      child: Text(symbol, style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = meteoData?['list'] as List<dynamic>? ?? const [];

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4ECF1),
        elevation: 0,
        title: Text(
          'Page Meteo Details ${widget.ville}',
          style: const TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      drawer: const MyDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Text(
                    'Aucune météo disponible pour ${widget.ville}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index] as Map<String, dynamic>;
                      final weather = (item['weather'] as List<dynamic>? ?? const [])
                          .firstWhere(
                            (entry) => entry is Map<String, dynamic>,
                            orElse: () => {'main': 'Clouds'},
                          ) as Map<String, dynamic>;
                      final temp = item['main']['temp'] as num? ?? 0;
                      final dt = item['dt'] as int? ?? 0;
                      final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
                      final main = weather['main']?.toString() ?? 'Clouds';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2EA9E6), Color(0xFF89D5F8)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              _weatherBadge(main),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('E-dd/MM/yyyy').format(date),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${DateFormat('HH:mm').format(date)} | $main',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${(temp - 273.15).round()} °C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
