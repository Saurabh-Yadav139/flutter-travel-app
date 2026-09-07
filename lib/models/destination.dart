// Simple data models for the Travel Planner app.
// Beginner-friendly: plain Dart classes with constructor and sample data.

class Destination {
  final String id;
  final String name;
  final String country;
  final String region;
  final double pricePerDay;
  final double rating;
  final String imageUrl;
  final String description;
  final List<String> highlights;
  final double latitude;
  final double longitude;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.pricePerDay,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.highlights,
    required this.latitude,
    required this.longitude,
  });
}

class ItineraryActivity {
  final String id;
  final int day;
  final String title;
  final String time;
  bool isDone;

  ItineraryActivity({
    required this.id,
    required this.day,
    required this.title,
    required this.time,
    this.isDone = false,
  });
}

class Booking {
  final String id;
  final String destinationName;
  final String travelerName;
  final String email;
  final DateTime startDate;
  final DateTime endDate;
  final int guests;
  final double totalCost;

  const Booking({
    required this.id,
    required this.destinationName,
    required this.travelerName,
    required this.email,
    required this.startDate,
    required this.endDate,
    required this.guests,
    required this.totalCost,
  });
}

// Initial curated travel destinations (with real high-res images and coordinates)
final List<Destination> sampleDestinations = [
  const Destination(
    id: '1',
    name: 'Paris',
    country: 'France',
    region: 'Europe',
    pricePerDay: 180,
    rating: 4.8,
    imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=900&q=80',
    description: 'Paris, France\'s capital, is a major European city and a global center for art, fashion, gastronomy and culture.',
    highlights: ['Eiffel Tower', 'Louvre Museum', 'Seine River Cruise', 'Montmartre'],
    latitude: 48.8566,
    longitude: 2.3522,
  ),
  const Destination(
    id: '2',
    name: 'Kyoto',
    country: 'Japan',
    region: 'Asia',
    pricePerDay: 140,
    rating: 4.9,
    imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=900&q=80',
    description: 'Kyoto is famous for its numerous classical Buddhist temples, gardens, imperial palaces, Shinto shrines and traditional wooden houses.',
    highlights: ['Fushimi Inari', 'Arashiyama Bamboo Grove', 'Kinkaku-ji', 'Gion District'],
    latitude: 35.0116,
    longitude: 135.7681,
  ),
  const Destination(
    id: '3',
    name: 'Rome',
    country: 'Italy',
    region: 'Europe',
    pricePerDay: 160,
    rating: 4.7,
    imageUrl: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?auto=format&fit=crop&w=900&q=80',
    description: 'Rome, the eternal city, is renowned for nearly 3,000 years of globally influential art, architecture and culture.',
    highlights: ['Colosseum', 'Vatican City', 'Trevi Fountain', 'Pantheon'],
    latitude: 41.9028,
    longitude: 12.4964,
  ),
  const Destination(
    id: '4',
    name: 'Bali',
    country: 'Indonesia',
    region: 'Asia',
    pricePerDay: 85,
    rating: 4.8,
    imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=900&q=80',
    description: 'Bali is an Indonesian island known for its forested volcanic mountains, iconic rice paddies, beaches and coral reefs.',
    highlights: ['Ubud Monkey Forest', 'Tegallalang Rice Terraces', 'Tanah Lot Temple', 'Kuta Beach'],
    latitude: -8.4095,
    longitude: 115.1889,
  ),
  const Destination(
    id: '5',
    name: 'Cairo',
    country: 'Egypt',
    region: 'Africa',
    pricePerDay: 95,
    rating: 4.6,
    imageUrl: 'https://images.unsplash.com/photo-1572252009286-268acec5ca0a?auto=format&fit=crop&w=900&q=80',
    description: 'Cairo, Egypt’s sprawling capital, is set on the Nile River. At its heart is Tahrir Square and the vast Egyptian Museum.',
    highlights: ['Giza Pyramids', 'The Sphinx', 'Egyptian Museum', 'Khan el-Khalili Bazaar'],
    latitude: 30.0444,
    longitude: 31.2357,
  ),
  const Destination(
    id: '6',
    name: 'New York',
    country: 'United States',
    region: 'Americas',
    pricePerDay: 220,
    rating: 4.7,
    imageUrl: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?auto=format&fit=crop&w=900&q=80',
    description: 'New York City comprises 5 boroughs sitting where the Hudson River meets the Atlantic Ocean, featuring world-class sights.',
    highlights: ['Central Park', 'Times Square', 'Statue of Liberty', 'Empire State Building'],
    latitude: 40.7128,
    longitude: -74.0060,
  ),
];

// Initial starter itinerary items
List<ItineraryActivity> defaultItineraryActivities = [
  ItineraryActivity(
    id: 'act-1',
    day: 1,
    title: 'Arrival & Hotel Check-in',
    time: '10:00 AM',
    isDone: true,
  ),
  ItineraryActivity(
    id: 'act-2',
    day: 1,
    title: 'Old Town Walking Tour & Local Cafe',
    time: '02:00 PM',
    isDone: true,
  ),
  ItineraryActivity(
    id: 'act-3',
    day: 2,
    title: 'Visit Famous Cultural Museum & Landmark',
    time: '09:30 AM',
    isDone: false,
  ),
  ItineraryActivity(
    id: 'act-4',
    day: 2,
    title: 'Scenic Sunset Viewpoint & Photography',
    time: '05:30 PM',
    isDone: false,
  ),
  ItineraryActivity(
    id: 'act-5',
    day: 3,
    title: 'Street Food Tour & Souvenir Shopping',
    time: '11:00 AM',
    isDone: false,
  ),
];
