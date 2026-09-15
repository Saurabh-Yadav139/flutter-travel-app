import 'dart:async';

/// Local Dummy Data Service for Travel Planner.
/// Provides mock destination details and weather locally without external API dependencies.
/// This keeps the app fast, reliable, and completely offline-friendly.
class TravelApiService {
  /// Fetches rich dummy overview and guide information for a destination
  static Future<Map<String, String?>?> fetchPlaceLiveInfo(String placeName) async {
    // Simulate a brief asynchronous response for realistic Flutter data flow
    await Future.delayed(const Duration(milliseconds: 150));

    final Map<String, String> dummyOverviews = {
      'Paris':
          'Paris offers romantic tree-lined boulevards, world-renowned art collections at the Louvre, the iconic Eiffel Tower, bohemian cafes in Montmartre, and sunset boat cruises along the Seine.',
      'Kyoto':
          'Kyoto was Japan\'s imperial capital for over a millennium. It is renowned for thousands of historic Buddhist temples, serene zen rock gardens, bamboo forests in Arashiyama, and traditional tea ceremonies.',
      'Rome':
          'Rome is an open-air museum where ancient history meets modern vitality. Explore the Colosseum, Roman Forum, Trevi Fountain, and the historic treasures of Vatican City.',
      'Bali':
          'Bali is Indonesia\'s premier tropical paradise. Famous for emerald rice terraces in Ubud, volcanic peaks, sacred seaside temples, surf beaches, and holistic retreats.',
      'Cairo':
          'Cairo stands on the banks of the Nile, famous for the monumental Pyramids of Giza, the Great Sphinx, the Grand Egyptian Museum, and lively traditional bazaars.',
      'New York':
          'New York City is a vibrant global metropolis featuring Central Park, Broadway theater, world-class shopping on 5th Avenue, and stunning views from the Empire State Building.',
    };

    final overview = dummyOverviews[placeName] ??
        'A magnificent destination celebrated for scenic landscapes, local gastronomy, and rich cultural traditions.';

    return {
      'extract': overview,
      'description': 'Curated Travel Guide',
    };
  }

  /// Fetches dummy weather and climate data for a destination
  static Future<Map<String, dynamic>?> fetchLiveWeather(double latitude, double longitude) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return {
      'temperature': '24°C',
      'wind': '10 km/h',
    };
  }
}
