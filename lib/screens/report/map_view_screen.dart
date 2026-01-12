import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/theme.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final MapController _mapController = MapController();
  String _selectedFilter = 'All';

  // Douala, Cameroon coordinates
  final LatLng _centerPoint = LatLng(4.0511, 9.7679);

  // Waste report markers
  final List<Map<String, dynamic>> _wasteReports = [
    {
      'id': 1,
      'type': 'Plastic',
      'location': 'Akwa District',
      'position': LatLng(4.0583, 9.7630),
      'status': 'Pending',
      'amount': '25kg',
      'reporter': 'Sarah M.',
      'time': '2 hours ago',
    },
    {
      'id': 2,
      'type': 'E-Waste',
      'location': 'Bonaberi',
      'position': LatLng(4.0666, 9.7000),
      'status': 'Verified',
      'amount': '15kg',
      'reporter': 'John D.',
      'time': '5 hours ago',
    },
    {
      'id': 3,
      'type': 'Organic',
      'location': 'Bonanjo',
      'position': LatLng(4.0450, 9.7800),
      'status': 'Collected',
      'amount': '40kg',
      'reporter': 'Marie K.',
      'time': '1 day ago',
    },
    {
      'id': 4,
      'type': 'Aluminum',
      'location': 'Makepe',
      'position': LatLng(4.0300, 9.7550),
      'status': 'Pending',
      'amount': '8kg',
      'reporter': 'Paul N.',
      'time': '3 hours ago',
    },
  ];

  Map<String, dynamic>? _selectedReport;

  Color _getMarkerColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Verified':
        return AppTheme.primary;
      case 'Collected':
        return Colors.grey;
      default:
        return AppTheme.primary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Plastic':
        return Icons.recycling;
      case 'E-Waste':
        return Icons.devices;
      case 'Organic':
        return Icons.eco;
      case 'Aluminum':
        return Icons.local_drink;
      default:
        return Icons.delete;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // REAL Leaflet Map using flutter_map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centerPoint,
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.trashcash.app',
              ),
              MarkerLayer(
                markers: _wasteReports
                    .where((report) =>
                _selectedFilter == 'All' || report['status'] == _selectedFilter)
                    .map((report) {
                  return Marker(
                    point: report['position'] as LatLng,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedReport = report;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getMarkerColor(report['status'] as String),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getTypeIcon(report['type'] as String),
                          color: Colors.white,
                          size: 20,
                        ),
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
                _buildFilterChips(),
              ],
            ),
          ),

          // Selected Report Card
          if (_selectedReport != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildReportCard(_selectedReport!),
            ),

          // Floating Action Button
          Positioned(
            bottom: _selectedReport != null ? 280 : 100,
            right: 16,
            child: _buildFAB(),
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
                    'Waste Reports Map',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Douala, Cameroon',
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

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Verified', 'Collected'];

    return FadeIn(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                      _selectedReport = null;
                    });
                  },
                  backgroundColor: AppTheme.surfaceDark,
                  selectedColor: AppTheme.primary.withOpacity(0.2),
                  checkmarkColor: AppTheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primary : Colors.white,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primary : const Color(0xFF283928),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF283928)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
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
                    color: _getMarkerColor(report['status'] as String).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(report['type'] as String),
                    color: _getMarkerColor(report['status'] as String),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${report['type']} Waste',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        report['location'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getMarkerColor(report['status'] as String).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getMarkerColor(report['status'] as String).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    report['status'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _getMarkerColor(report['status'] as String),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary, size: 20),
                  onPressed: () {
                    setState(() {
                      _selectedReport = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF283928)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(Icons.scale, 'Amount', report['amount'] as String),
                ),
                Expanded(
                  child: _buildInfoItem(Icons.person, 'Reporter', report['reporter'] as String),
                ),
                Expanded(
                  child: _buildInfoItem(Icons.access_time, 'Reported', report['time'] as String),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _mapController.move(report['position'] as LatLng, 16.0);
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Directions'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF283928)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/schedule-pickup');
                    },
                    icon: const Icon(Icons.local_shipping, size: 18),
                    label: const Text('Pickup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.black,
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

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return FadeIn(
      delay: const Duration(milliseconds: 400),
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create-report');
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_location),
        label: const Text(
          'Report Waste',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}