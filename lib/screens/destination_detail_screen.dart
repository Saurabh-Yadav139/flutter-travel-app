import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/travel_api_service.dart';

/// Detailed Place Page.
/// Displays destination hero image, live weather, live Wikipedia overview,
/// trip highlights, sample itinerary, and a direct booking button.
class DestinationDetailScreen extends StatefulWidget {
  final Destination destination;
  final Function(String destinationName)? onBookNow;

  const DestinationDetailScreen({
    super.key,
    required this.destination,
    this.onBookNow,
  });

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  bool _isFavorite = false;
  String? _liveDescription;
  String? _liveWeather;
  bool _isLoadingLive = true;

  @override
  void initState() {
    super.initState();
    _loadLivePlaceData();
  }

  // Fetch real-time data from Wikipedia and Open-Meteo APIs
  Future<void> _loadLivePlaceData() async {
    final wikiInfo = await TravelApiService.fetchPlaceLiveInfo(widget.destination.name);
    final weatherInfo = await TravelApiService.fetchLiveWeather(
      widget.destination.latitude,
      widget.destination.longitude,
    );

    if (mounted) {
      setState(() {
        if (wikiInfo != null && wikiInfo['extract'] != null && wikiInfo['extract']!.isNotEmpty) {
          _liveDescription = wikiInfo['extract'];
        }
        if (weatherInfo != null && weatherInfo['temperature'] != null) {
          _liveWeather = weatherInfo['temperature'];
        }
        _isLoadingLive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dest = widget.destination;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with large Destination Image and Hero animation
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.redAccent : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isFavorite ? 'Saved to Favorites!' : 'Removed from Favorites',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'dest-${dest.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      dest.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.teal.shade200,
                        child: const Icon(Icons.landscape, size: 80, color: Colors.white),
                      ),
                    ),
                    // Gradient overlay for better text readability
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Place Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Destination Name & Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dest.name,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 18, color: Colors.teal),
                                const SizedBox(width: 4),
                                Text(
                                  '${dest.country} • ${dest.region}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Rating badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              dest.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Highlights Stats Row (Price, Weather from Live API, Category)
                  Row(
                    children: [
                      _buildStatCard(
                        icon: Icons.attach_money,
                        title: 'Daily Cost',
                        value: '\$${dest.pricePerDay.toInt()}/day',
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Live Weather',
                        value: _liveWeather ?? '22°C',
                        color: Colors.orange,
                        isLive: _liveWeather != null,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.category_outlined,
                        title: 'Type',
                        value: dest.region,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // About Section
                  Row(
                    children: [
                      Text(
                        'About Destination',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_liveDescription != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            border: Border.all(color: Colors.teal.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Live Wikipedia',
                            style: TextStyle(fontSize: 10, color: Colors.teal, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingLive)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(minHeight: 2),
                    ),
                  Text(
                    _liveDescription ?? dest.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Highlights Tags
                  Text(
                    'Trip Highlights',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dest.highlights.map((highlight) {
                      return Chip(
                        avatar: const Icon(Icons.check_circle_outline, size: 16, color: Colors.teal),
                        label: Text(highlight),
                        backgroundColor: Colors.teal.shade50,
                        side: BorderSide(color: Colors.teal.shade100),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Suggested Itinerary Section
                  Text(
                    'Suggested 3-Day Plan',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildItineraryCard(1, 'Arrival & Historic Center', 'Check-in, orientation walk, and welcome dinner'),
                  _buildItineraryCard(2, 'Major Sights & Museums', 'Visit top-rated landmarks and iconic viewpoints'),
                  _buildItineraryCard(3, 'Local Flavors & Leisure', 'Explore artisanal markets and scenic evening boat/city tour'),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Bar with Price and Book Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxBarShadow(),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price starts at', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    '\$${dest.pricePerDay.toInt()}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (widget.onBookNow != null) {
                    widget.onBookNow!(dest.name);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.calendar_month),
                label: const Text(
                  'Book This Trip',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isLive = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryCard(int day, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          foregroundColor: Colors.teal.shade900,
          child: Text('$day', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

// Helper box shadow for clean bottom bar
class BoxBarShadow extends BoxShadow {
  BoxBarShadow()
      : super(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, -4),
        );
}
