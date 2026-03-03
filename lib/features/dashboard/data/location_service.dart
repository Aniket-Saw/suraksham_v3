import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);
  @override
  String toString() => message;
}

class LocationData {
  final Position position;
  final String locality;

  LocationData({required this.position, required this.locality});
}

class LocationService {
  Future<LocationData> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationServiceException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
        'Location permissions are permanently denied.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    String locality = "Unknown Location";
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.locality,
          place.administrativeArea,
        ].whereType<String>().where((e) => e.isNotEmpty).toList();
        locality = parts.join(', ');
        if (locality.isEmpty) {
          locality = place.country ?? "Unknown Location";
        }
      }
    } catch (e) {
      // Fallback
    }

    return LocationData(position: position, locality: locality);
  }
}
