import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class AddressConverter {
  static Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) {
        return 'Invalid coordinates';
      }

      print('Getting address for: ($latitude, $longitude)');
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        String address = [
          placemark.street,
          placemark.subLocality,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country,
        ].where((e) => e != null && e!.isNotEmpty).map((e) => e!).join(', ');
        return address.isNotEmpty ? address : 'No address found';
      } else {
        return 'No address found';
      }
    } catch (e) {
      print('Geocoding error: $e');
      return 'Error fetching address';
    }
  }
}

class LocationText extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String? location;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocationText({
    super.key,
    this.latitude,
    this.longitude,
    this.location,
    this.style,
    this.maxLines,
    this.overflow,
  });

  Future<String> _getDisplayText() async {
    if (location != null && location!.isNotEmpty) {
      return 'Selected Location: $location';
    } else if (latitude != null && longitude != null) {
      return await AddressConverter.getAddressFromCoordinates(
        latitude: latitude!,
        longitude: longitude!,
      );
    }
    return 'No location available';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getDisplayText(),
      builder: (context, snapshot) {
        String displayText;
        if (snapshot.connectionState == ConnectionState.waiting) {
          displayText = 'Loading location...';
        } else if (snapshot.hasError || !snapshot.hasData) {
          displayText = 'Error loading location';
        } else {
          displayText = snapshot.data!;
        }
        return Text(
          displayText,
          style: style ??
              const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
          maxLines: maxLines ?? 2,
          overflow: overflow ?? TextOverflow.ellipsis,
        );
      },
    );
  }
}
