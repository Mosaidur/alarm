import 'package:flutter/material.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../networks/location_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _location;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      setState(() {
        _location = "Lat: ${position.latitude}, Long: ${position.longitude}";
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: _location,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20), // Dark background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome! Your Personalized Alarm",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Allow us to sync your sunset alarm based on your location.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Image.asset(
                'assets/images/location.png',
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              CustomButton(
                label: _isLoading ? "Fetching Location..." : "Use Current Location",
                onPressed: _isLoading ? () {} : _getLocation,
                icon: Icons.location_on,
                backgroundColor: const Color(0xFFAB47BC), // Purple accent
              ),
              const SizedBox(height: 10),
              CustomButton(
                label: "Skip Location",
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                backgroundColor: const Color(0xFF3A3A3A), // Darker gray
                textColor: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}