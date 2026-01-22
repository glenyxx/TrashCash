import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/theme.dart';

class EWasteLocatorScreen extends StatefulWidget {
  const EWasteLocatorScreen({super.key});

  @override
  State<EWasteLocatorScreen> createState() => _EWasteLocatorScreenState();
}

class _EWasteLocatorScreenState extends State<EWasteLocatorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MapController _mapController = MapController();
  String _selectedFilter = 'All';
  Map<String, dynamic>? _selectedLocation;
  bool _isFabVisible = true;

  // Douala, Cameroon coordinates
  final LatLng _centerPoint = LatLng(4.0511, 9.7679);

  // E-Waste drop-off locations
  final List<Map<String, dynamic>> _dropOffLocations = [
    {
      'id': 1,
      'name': 'TrashCash Central Hub',
      'type': 'Official Center',
      'position': LatLng(4.0583, 9.7630),
      'address': 'Akwa District, Rue de la Liberté',
      'hours': 'Mon-Sat: 8AM-6PM',
      'phone': '+237 677 00 00 01',
      'accepts': ['E-Waste', 'Plastic', 'Aluminum', 'Glass'],
      'rating': 4.9,
      'distance': '2.3 km',
      'verified': true,
    },
    {
      'id': 2,
      'name': 'Bonaberi Collection Point',
      'type': 'Drop-off Point',
      'position': LatLng(4.0666, 9.7000),
      'address': 'Bonaberi Industrial Zone',
      'hours': 'Mon-Fri: 9AM-5PM',
      'phone': '+237 677 00 00 02',
      'accepts': ['E-Waste', 'Batteries'],
      'rating': 4.7,
      'distance': '5.8 km',
      'verified': true,
    },
    {
      'id': 3,
      'name': 'Bonanjo Recycling Station',
      'type': 'Official Center',
      'position': LatLng(4.0450, 9.7800),
      'address': 'Bonanjo, Near Port Authority',
      'hours': 'Mon-Sat: 7AM-7PM',
      'phone': '+237 677 00 00 03',
      'accepts': ['E-Waste', 'Plastic', 'Paper'],
      'rating': 4.8,
      'distance': '3.1 km',
      'verified': true,
    },
    {
      'id': 4,
      'name': 'Makepe Community Center',
      'type': 'Community Hub',
      'position': LatLng(4.0300, 9.7550),
      'address': 'Makepe Missoke',
      'hours': 'Tue-Sun: 10AM-4PM',
      'phone': '+237 677 00 00 04',
      'accepts': ['E-Waste', 'Organic'],
      'rating': 4.5,
      'distance': '4.2 km',
      'verified': false,
    },
  ];

  Color _getMarkerColor(String type) {
    switch (type) {
      case 'Official Center':
        return AppTheme.primary;
      case 'Drop-off Point':
        return Colors.blue.shade600;
      case 'Community Hub':
        return Colors.purple.shade600;
      default:
        return AppTheme.primary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Official Center':
        return Icons.store;
      case 'Drop-off Point':
        return Icons.pin_drop;
      case 'Community Hub':
        return Icons.groups;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // REAL Leaflet Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centerPoint,
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 18.0,
              onTap: (_, __) {
                if (_selectedLocation != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _selectedLocation = null;
                      });
                    }
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.trashcash.app',
              ),
              MarkerLayer(
                markers: _dropOffLocations.map((location) {
                  return Marker(
                    point: location['position'] as LatLng,
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _selectedLocation = location;
                            });
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getMarkerColor(location['type'] as String),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getTypeIcon(location['type'] as String),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 10,
                            color: _getMarkerColor(location['type'] as String),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top Bar
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildLegend(),
              ],
            ),
          ),

          // Selected Location Card
          if (_selectedLocation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: false,
                child: _buildLocationCard(_selectedLocation!),
              ),
            ),

          // Floating Action Button with AnimatedPositioned
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _selectedLocation != null ? 320 : 100,
            right: 16,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: _isFabVisible ? 1.0 : 0.0,
              child: _buildFAB(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return FadeInDown(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF283928)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'E-Waste Drop-off Locator',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Find verified collection centers near you',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.my_location, color: AppTheme.primary),
              onPressed: () {
                _mapController.move(_centerPoint, 13.0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return FadeIn(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search by location or name...',
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
            prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
            suffixIcon: IconButton(
              icon: const Icon(Icons.filter_list, color: AppTheme.primary),
              onPressed: () {},
            ),
            filled: true,
            fillColor: AppTheme.surfaceDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF283928)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF283928)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return FadeIn(
      delay: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF283928)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLegendItem(AppTheme.primary, 'Official'),
            const SizedBox(width: 16),
            _buildLegendItem(Colors.blue.shade600, 'Drop-off'),
            const SizedBox(width: 16),
            _buildLegendItem(Colors.purple.shade600, 'Community'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF283928)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getMarkerColor(location['type'] as String).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(location['type'] as String),
                    color: _getMarkerColor(location['type'] as String),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              location['name'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (location['verified'] as bool)
                            const Icon(Icons.verified, color: AppTheme.primary, size: 20),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location['type'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getMarkerColor(location['type'] as String),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary, size: 20),
                  onPressed: () {
                    setState(() {
                      _selectedLocation = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF283928)),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, location['address'] as String),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.access_time, location['hours'] as String),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.phone, location['phone'] as String),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${location['rating']} rating',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.near_me, color: AppTheme.primary, size: 18),
                const SizedBox(width: 6),
                Text(
                  location['distance'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Accepts:',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (location['accepts'] as List<String>).map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _mapController.move(location['position'] as LatLng, 16.0);
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Directions'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF283928)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return FadeIn(
      delay: const Duration(milliseconds: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'list',
            onPressed: () {
              _showLocationsList();
            },
            backgroundColor: AppTheme.surfaceDark,
            child: const Icon(Icons.list, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'report',
            onPressed: () {},
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.black,
            icon: const Icon(Icons.add),
            label: const Text(
              'Report Location',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationsList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF283928)),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'All Locations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _dropOffLocations.length,
                itemBuilder: (context, index) {
                  final location = _dropOffLocations[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2C1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF283928)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                location['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (location['verified'] as bool)
                              const Icon(Icons.verified, color: AppTheme.primary, size: 18),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          location['address'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${location['rating']}',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.near_me, color: AppTheme.primary, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              location['distance'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}