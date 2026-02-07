import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

/// Weather Service using Open-Meteo API (free, no API key required)
/// Provides temperature data for Ice pet
class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  
  // Cold air sources with fixed coordinates
  static const Map<String, Map<String, double>> coldAirSources = {
    'Siberian Cold Air': {'lat': 66.0, 'lon': 94.0},
    'Antarctic Air': {'lat': -75.0, 'lon': 0.0},
    'Arctic Air': {'lat': 85.0, 'lon': 0.0},
    'Deep Cave Air': {'lat': 45.0, 'lon': 14.0}, // Postojna Cave, Slovenia
  };
  
  /// Get current temperature at user's location
  static Future<double?> getCurrentTemperature() async {
    try {
      final position = await _getCurrentPosition();
      if (position == null) return null;
      
      final url = '$_baseUrl?latitude=${position.latitude}&longitude=${position.longitude}&current_weather=true';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['current_weather']?['temperature']?.toDouble();
      }
    } catch (e) {
      print('Weather API error: $e');
    }
    return null;
  }
  
  /// Get temperature from a cold air source
  static Future<double?> getTemperatureFrom(String source) async {
    try {
      final coords = coldAirSources[source];
      if (coords == null) return null;
      
      final url = '$_baseUrl?latitude=${coords['lat']}&longitude=${coords['lon']}&current_weather=true';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['current_weather']?['temperature']?.toDouble();
      }
    } catch (e) {
      print('Weather API error: $e');
    }
    return null;
  }
  
  /// Get user's current position
  static Future<Position?> _getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;
      
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Location error: $e');
      return null;
    }
  }
  
  /// Check if temperature is dangerous for Ice (>15°C = melting)
  static bool isDangerousTemp(double temp) => temp > 15.0;
  
  /// Check if temperature is perfect for Ice (<0°C = happy)
  static bool isPerfectTemp(double temp) => temp < 0.0;
}
