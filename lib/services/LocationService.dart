// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }
      
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
      
      return null;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<bool> openGoogleMaps({
    required double destinationLat,
    required double destinationLng,
    Position? currentPosition,
  }) async {
    try {
      String url;
      
      if (currentPosition != null) {
        url = 'https://www.google.com/maps/dir/'
            '${currentPosition.latitude},${currentPosition.longitude}/'
            '$destinationLat,$destinationLng';
      } else {
        url = 'https://www.google.com/maps/search/'
            '$destinationLat,$destinationLng';
      }
      
      if (await canLaunch(url)) {
        await launch(url);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error opening Google Maps: $e');
      return false;
    }
  }

  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // Convert to km
  }

  static LatLng getDefaultLocation() {
    return const LatLng(23.2599, 77.4126); // Bhopal coordinates
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<LocationPermission> getLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}