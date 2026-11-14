import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../menu/drawer.widget.dart';
import 'maps-details.page.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _cityController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openMap({
    String latitude = '',
    String longitude = '',
    String city = '',
  }) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MapsDetailsPage(
          latitude: latitude,
          longitude: longitude,
          ville: city,
        ),
      ),
    );
    if (!mounted) return;
    _cityController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
  }

  Future<void> _search() async {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      await _openMap(city: city);
      return;
    }

    final latitudeText = _latitudeController.text.trim();
    final longitudeText = _longitudeController.text.trim();
    final latitude = double.tryParse(latitudeText);
    final longitude = double.tryParse(longitudeText);

    if (latitude == null ||
        longitude == null ||
        !latitude.isFinite ||
        !longitude.isFinite ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      _showMessage('Saisissez une ville ou des coordonnées valides.');
      return;
    }

    await _openMap(latitude: latitudeText, longitude: longitudeText);
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;
      if (!serviceEnabled) {
        _showMessage('Veuillez activer les services de localisation.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (!mounted) return;
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (!mounted) return;
      }
      if (permission == LocationPermission.denied) {
        _showMessage('Permission de localisation refusée.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _showMessage(
          'Permission refusée définitivement. Autorisez la localisation dans les paramètres.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      await _openMap(
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
    } catch (error) {
      debugPrint('Erreur de géolocalisation: $error');
      if (mounted) {
        _showMessage('Impossible d’obtenir votre position actuelle.');
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  Widget _coordinateField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.location_on),
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4ECF1),
        elevation: 0,
        title: const Text('Page Maps', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            TextFormField(
              controller: _cityController,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (_) => _search(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_city),
                hintText: 'Nom de ville',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  'OU',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _coordinateField(
              controller: _latitudeController,
              label: 'Latitude',
            ),
            _coordinateField(
              controller: _longitudeController,
              label: 'Longitude',
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _search,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7E1E7),
                  foregroundColor: Colors.black87,
                ),
                child: const Text(
                  'Chercher',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isGettingLocation ? null : _getCurrentLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                icon: _isGettingLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.my_location),
                label: const Text(
                  'Ma position actuelle',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
