import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../menu/drawer.widget.dart';

class MapsDetailsPage extends StatefulWidget {
  const MapsDetailsPage({
    this.latitude = '',
    this.longitude = '',
    this.ville = '',
    super.key,
  });

  final String latitude;
  final String longitude;
  final String ville;

  @override
  State<MapsDetailsPage> createState() => _MapsDetailsPageState();
}

class _MapsDetailsPageState extends State<MapsDetailsPage> {
  static const _geocodingApiKey = String.fromEnvironment(
    'GOOGLE_GEOCODING_API_KEY',
  );

  LatLng? _position;
  String? _errorMessage;
  String? _address;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.ville.trim().isNotEmpty) {
      _getLocationByCity(widget.ville.trim());
    } else {
      _setCoordinates(widget.latitude, widget.longitude);
    }
  }

  void _setCoordinates(String latitude, String longitude) {
    final lat = double.tryParse(latitude);
    final lng = double.tryParse(longitude);
    if (lat == null ||
        lng == null ||
        !lat.isFinite ||
        !lng.isFinite ||
        lat < -90 ||
        lat > 90 ||
        lng < -180 ||
        lng > 180) {
      setState(() {
        _errorMessage = 'Les coordonnées fournies ne sont pas valides.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _position = LatLng(lat, lng);
      _address = 'Lat: $lat, Lng: $lng';
      _isLoading = false;
    });
  }

  Future<void> _getLocationByCity(String city) async {
    try {
      final result = !kIsWeb && _geocodingApiKey.isNotEmpty
          ? await _getGoogleLocation(city)
          : await _getOpenStreetMapLocation(city);

      if (!mounted) return;
      setState(() {
        _position = result.$1;
        _address = result.$2;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Erreur de recherche de ville: $error');
      if (!mounted) return;
      setState(() {
        _errorMessage = error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : 'Impossible de rechercher cette ville.';
        _isLoading = false;
      });
    }
  }

  Future<(LatLng, String)> _getGoogleLocation(String city) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'address': city,
      'key': _geocodingApiKey,
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception(
        'Erreur HTTP ${response.statusCode} pendant la recherche.',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? const [];
    if (data['status'] != 'OK' || results.isEmpty) {
      final status = data['status']?.toString() ?? 'UNKNOWN_ERROR';
      throw Exception(
        status == 'ZERO_RESULTS'
            ? 'Aucun résultat trouvé pour « $city ».'
            : 'La recherche Google a échoué ($status).',
      );
    }

    final result = results.first as Map<String, dynamic>;
    final location =
        (result['geometry'] as Map<String, dynamic>)['location']
            as Map<String, dynamic>;
    final latitude = (location['lat'] as num).toDouble();
    final longitude = (location['lng'] as num).toDouble();
    if (!_isValidCoordinates(latitude, longitude)) {
      throw const FormatException('Coordonnées de ville invalides.');
    }

    return (
      LatLng(latitude, longitude),
      result['formatted_address']?.toString() ?? city,
    );
  }

  Future<(LatLng, String)> _getOpenStreetMapLocation(String city) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': city,
      'format': 'jsonv2',
      'limit': '10',
    });
    final response = await http
        .get(uri, headers: {'Accept-Language': 'fr'})
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception(
        'Le service de recherche de ville est indisponible '
        '(HTTP ${response.statusCode}).',
      );
    }

    final results = jsonDecode(response.body) as List<dynamic>;
    if (results.isEmpty) {
      throw Exception('Aucun résultat trouvé pour « $city ».');
    }

    final settlementTypes = {'city', 'town', 'village', 'hamlet', 'suburb'};
    final settlements = results.whereType<Map<String, dynamic>>().where(
      (result) =>
          result['category'] == 'place' &&
          settlementTypes.contains(result['type']),
    );
    final settlementList = settlements.toList();
    final result = settlementList.isNotEmpty
        ? settlementList.first
        : results.first as Map<String, dynamic>;
    final latitude = double.parse(result['lat'] as String);
    final longitude = double.parse(result['lon'] as String);
    if (!_isValidCoordinates(latitude, longitude)) {
      throw const FormatException('Coordonnées de ville invalides.');
    }

    return (
      LatLng(latitude, longitude),
      result['display_name']?.toString() ?? city,
    );
  }

  bool _isValidCoordinates(double latitude, double longitude) =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;

  @override
  Widget build(BuildContext context) {
    final position = _position;
    return Scaffold(
      appBar: AppBar(title: const Text('Page Maps Details')),
      drawer: const MyDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : position == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_searching,
                      size: 48,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage ?? 'Position indisponible.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Retour à la recherche'),
                    ),
                  ],
                ),
              ),
            )
          : FlutterMap(
              options: MapOptions(initialCenter: position, initialZoom: 14),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.my_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: position,
                      width: 48,
                      height: 48,
                      child: Tooltip(
                        message: _address ?? widget.ville,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 44,
                        ),
                      ),
                    ),
                  ],
                ),
                RichAttributionWidget(
                  showFlutterMapAttribution: false,
                  attributions: [
                    TextSourceAttribution('© OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
    );
  }
}
