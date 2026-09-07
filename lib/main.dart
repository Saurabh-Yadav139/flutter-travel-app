import 'package:flutter/material.dart';
import 'models/destination.dart';
import 'screens/destination_detail_screen.dart';

void main() {
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Current active tab index (0: Explore, 1: Itinerary, 2: Bookings)
  int _currentTabIndex = 0;

  // Selected destination to prefill when switching from detail page to booking
  String _selectedDestinationForBooking = sampleDestinations.first.name;

  // App-level itinerary list
  final List<ItineraryActivity> _activities = List.from(defaultItineraryActivities);

  // App-level bookings list
  final List<Booking> _confirmedBookings = [];

  void _navigateToBookingWithDestination(String destinationName) {
    setState(() {
      _selectedDestinationForBooking = destinationName;
      _currentTabIndex = 2; // Switch to Booking Form tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ExploreTab(
        onDestinationBookPressed: _navigateToBookingWithDestination,
      ),
      ItineraryTab(
        activities: _activities,
        onAddActivity: (activity) {
          setState(() {
            _activities.add(activity);
          });
        },
        onToggleActivity: (activity) {
          setState(() {
            activity.isDone = !activity.isDone;
          });
        },
        onDeleteActivity: (activity) {
          setState(() {
            _activities.remove(activity);
          });
        },
      ),
      BookingTab(
        initialDestination: _selectedDestinationForBooking,
        confirmedBookings: _confirmedBookings,
        onBookingCreated: (newBooking) {
          setState(() {
            _confirmedBookings.insert(0, newBooking);
          });
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(child: tabs[_currentTabIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Itinerary',
          ),
          NavigationDestination(
            icon: Icon(Icons.airplane_ticket_outlined),
            selectedIcon: Icon(Icons.airplane_ticket),
            label: 'Book Trip',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 1: EXPLORE DESTINATIONS
// ---------------------------------------------------------------------------
class ExploreTab extends StatefulWidget {
  final Function(String destinationName) onDestinationBookPressed;

  const ExploreTab({
    super.key,
    required this.onDestinationBookPressed,
  });

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Europe', 'Asia', 'Americas', 'Africa'];

  @override
  Widget build(BuildContext context) {
    // Filter destinations based on search query and selected region
    final filteredDestinations = sampleDestinations.where((dest) {
      final matchesCategory = _selectedCategory == 'All' || dest.region == _selectedCategory;
      final matchesSearch = dest.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dest.country.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Greeting & Search
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.travel_explore, color: Colors.teal, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Travel Planner',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Explore popular destinations and plan your dream trip',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              // Search input
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search destinations, countries...',
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ],
          ),
        ),

        // Category Filter Chips
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                selectedColor: Colors.teal.shade100,
                checkmarkColor: Colors.teal,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.teal.shade900 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              );
            },
          ),
        ),

        // Destination Cards List
        Expanded(
          child: filteredDestinations.isEmpty
              ? const Center(child: Text('No destinations found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDestinations.length,
                  itemBuilder: (context, index) {
                    final destination = filteredDestinations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigate to Detailed Place Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DestinationDetailScreen(
                                destination: destination,
                                onBookNow: widget.onDestinationBookPressed,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image with Hero and overlay chips
                            Stack(
                              children: [
                                Hero(
                                  tag: 'dest-${destination.id}',
                                  child: Image.network(
                                    destination.imageUrl,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 180,
                                      color: Colors.teal.shade200,
                                      child: const Icon(Icons.image, size: 50, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star, size: 16, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${destination.rating}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        destination.name,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '\$${destination.pricePerDay.toInt()}/day',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${destination.country} • ${destination.region}',
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    destination.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 2: ITINERARY PLANNER
// ---------------------------------------------------------------------------
class ItineraryTab extends StatefulWidget {
  final List<ItineraryActivity> activities;
  final Function(ItineraryActivity) onAddActivity;
  final Function(ItineraryActivity) onToggleActivity;
  final Function(ItineraryActivity) onDeleteActivity;

  const ItineraryTab({
    super.key,
    required this.activities,
    required this.onAddActivity,
    required this.onToggleActivity,
    required this.onDeleteActivity,
  });

  @override
  State<ItineraryTab> createState() => _ItineraryTabState();
}

class _ItineraryTabState extends State<ItineraryTab> {
  int _selectedDay = 0; // 0 = All Days

  void _showAddActivityDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '10:00 AM');
    int selectedDay = 1;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Itinerary Activity'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: selectedDay,
                  decoration: const InputDecoration(labelText: 'Trip Day'),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Day 1')),
                    DropdownMenuItem(value: 2, child: Text('Day 2')),
                    DropdownMenuItem(value: 3, child: Text('Day 3')),
                    DropdownMenuItem(value: 4, child: Text('Day 4')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedDay = val);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Activity Name',
                    hintText: 'e.g. Visit Museum, Boat Tour',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Scheduled Time',
                    hintText: 'e.g. 02:30 PM',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  final newActivity = ItineraryActivity(
                    id: 'act-${DateTime.now().millisecondsSinceEpoch}',
                    day: selectedDay,
                    title: titleController.text.trim(),
                    time: timeController.text.trim(),
                  );
                  widget.onAddActivity(newActivity);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.activities.where((act) {
      if (_selectedDay == 0) return true;
      return act.day == _selectedDay;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddActivityDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Activity'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Trip Itinerary 🗺️',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your schedule, check off completed activities, and add custom plans.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Day Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [0, 1, 2, 3, 4].map((day) {
                final isSelected = _selectedDay == day;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(day == 0 ? 'All Days' : 'Day $day'),
                    selected: isSelected,
                    selectedColor: Colors.teal.shade100,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDay = day;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Activities List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_note, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No activities for this day yet.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isDone,
                            activeColor: Colors.teal,
                            onChanged: (_) => widget.onToggleActivity(item),
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: item.isDone ? TextDecoration.lineThrough : null,
                              color: item.isDone ? Colors.grey : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            'Day ${item.day} • ${item.time}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                            onPressed: () => widget.onDeleteActivity(item),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 3: BOOKING FORM
// ---------------------------------------------------------------------------
class BookingTab extends StatefulWidget {
  final String initialDestination;
  final List<Booking> confirmedBookings;
  final Function(Booking) onBookingCreated;

  const BookingTab({
    super.key,
    required this.initialDestination,
    required this.confirmedBookings,
    required this.onBookingCreated,
  });

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  final _formKey = GlobalKey<FormState>();

  late String _destination;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 12));
  int _guests = 1;
  String _packageType = 'Standard';

  @override
  void initState() {
    super.initState();
    _destination = widget.initialDestination;
  }

  @override
  void didUpdateWidget(covariant BookingTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDestination != widget.initialDestination) {
      _destination = widget.initialDestination;
    }
  }

  // Calculate estimated total based on days, guests, destination rate, and package
  double _calculateTotalCost() {
    final destObj = sampleDestinations.firstWhere(
      (d) => d.name == _destination,
      orElse: () => sampleDestinations.first,
    );
    final days = _endDate.difference(_startDate).inDays;
    final totalDays = days > 0 ? days : 1;
    final basePrice = destObj.pricePerDay * totalDays * _guests;
    final packageMultiplier = _packageType == 'Luxury' ? 1.3 : 1.0;
    return basePrice * packageMultiplier;
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final total = _calculateTotalCost();
      final newBooking = Booking(
        id: 'TRV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        destinationName: _destination,
        travelerName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        guests: _guests,
        totalCost: total,
      );

      widget.onBookingCreated(newBooking);

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.teal, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text('Booking Confirmed!'),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking ID: ${newBooking.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              Text('Destination: ${newBooking.destinationName}'),
              Text('Lead Traveler: ${newBooking.travelerName}'),
              Text('Travelers: ${newBooking.guests} person(s)'),
              Text(
                'Dates: ${_startDate.month}/${_startDate.day} - ${_endDate.month}/${_endDate.day}/${_endDate.year}',
              ),
              const SizedBox(height: 8),
              Text(
                'Estimated Total: \$${total.toInt()}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              const Text('A confirmation email has been simulated to your inbox.'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _nameController.clear();
                _emailController.clear();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip Booking Form 🎫',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Reserve your flights and hotel package with quick confirmation.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),

            // Main Booking Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Destination Selector
                    DropdownButtonFormField<String>(
                      initialValue: _destination,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Select Destination',
                        prefixIcon: Icon(Icons.flight_takeoff, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                      items: sampleDestinations.map((d) {
                        return DropdownMenuItem(
                          value: d.name,
                          child: Text('${d.name} (${d.country})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _destination = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Full Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Address
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Travel Dates (Date Picker)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() {
                                  _startDate = picked;
                                  if (_endDate.isBefore(_startDate)) {
                                    _endDate = _startDate.add(const Duration(days: 3));
                                  }
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Departure Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_month, color: Colors.teal),
                              ),
                              child: Text('${_startDate.month}/${_startDate.day}/${_startDate.year}'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: _startDate,
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() {
                                  _endDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Return Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_month, color: Colors.teal),
                              ),
                              child: Text('${_endDate.month}/${_endDate.day}/${_endDate.year}'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Number of Travelers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Number of Travelers:',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            IconButton.filledTonal(
                              onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                '$_guests',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () => setState(() => _guests++),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Package Tier
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        const Text('Package: ', style: TextStyle(fontWeight: FontWeight.w500)),
                        ChoiceChip(
                          label: const Text('Standard'),
                          selected: _packageType == 'Standard',
                          onSelected: (_) => setState(() => _packageType = 'Standard'),
                        ),
                        ChoiceChip(
                          label: const Text('Luxury (+30%)'),
                          selected: _packageType == 'Luxury',
                          onSelected: (_) => setState(() => _packageType = 'Luxury'),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Cost estimation summary
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Estimated Total:',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            '\$${_calculateTotalCost().toInt()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.teal.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'Confirm & Book Trip',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Confirmed Bookings History Section
            if (widget.confirmedBookings.isNotEmpty) ...[
              const Text(
                'My Confirmed Trips',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.confirmedBookings.length,
                itemBuilder: (context, index) {
                  final b = widget.confirmedBookings[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.airplane_ticket, color: Colors.white),
                      ),
                      title: Text(
                        '${b.destinationName} • \$${b.totalCost.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Traveler: ${b.travelerName} • ${b.guests} guest(s)\nRef: ${b.id}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
