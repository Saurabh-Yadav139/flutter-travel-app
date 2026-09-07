import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch live travel information from 100% free, public APIs.
/// - Wikipedia REST API: Provides live destination summaries and real photos.
/// - Open-Meteo API: Provides real-time weather and temperature without any API key.
class TravelApiService {
  // Fetch summary and image for a place from Wikipedia API
  static Future<Map<String, String?>?> fetchPlaceLiveInfo(String placeName) async {
    try {
      final url = Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(placeName)}',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'FlutterTravelApp/1.0 (travel_planner_beginner_project)',
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final extract = data['extract'] as String?;
        final thumbnail = data['thumbnail'] != null ? data['thumbnail']['source'] as String? : null;
        final description = data['description'] as String?;

        return {
          'extract': extract,
          'thumbnail': thumbnail,
          'description': description,
        };
      }
    } catch (e) {
      // If offline or request fails, gracefully return null so app uses default data
      // ponytail: naive fallback to avoid breaking UI on network failure
    }
    return null;
  }

  // Fetch live temperature and weather condition from Open-Meteo API
  static Future<Map<String, dynamic>?> fetchLiveWeather(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final currentWeather = data['current_weather'];
        if (currentWeather != null) {
          final temp = currentWeather['temperature'];
          final wind = currentWeather['windspeed'];
          return {
            'temperature': '$temp°C',
            'wind': '$wind km/h',
          };
        }
      }
    } catch (e) {
      // Gracefully ignore network errors and let UI show standard weather
      // ponytail: safe fallback for network timeout
    }
    return null;
  }
}
