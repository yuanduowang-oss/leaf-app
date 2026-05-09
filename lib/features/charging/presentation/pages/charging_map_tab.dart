import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../../../core/theme/app_theme.dart';

class ChargingStation {
  final String name;
  final ll.LatLng location;
  final double distance;
  final String power;
  final int available;
  final double price;
  final bool isFast;
  final bool isFree;
  final bool is24h;

  ChargingStation({
    required this.name,
    required this.location,
    required this.distance,
    required this.power,
    required this.available,
    required this.price,
    this.isFast = false,
    this.isFree = false,
    this.is24h = false,
  });
}

class ChargingMapTab extends StatefulWidget {
  const ChargingMapTab({super.key});

  @override
  State<ChargingMapTab> createState() => _ChargingMapTabState();
}

class _ChargingMapTabState extends State<ChargingMapTab> {
  final MapController _mapController = MapController();

  final List<ChargingStation> _stations = [
    ChargingStation(name: '特来电 快充站', location: ll.LatLng(39.9065, 116.4050), distance: 350, power: '120kW', available: 8, price: 1.2, isFast: true, is24h: true),
    ChargingStation(name: '国家电网 充电站', location: ll.LatLng(39.9025, 116.4100), distance: 800, power: '60kW', available: 12, price: 1.0),
    ChargingStation(name: '星星充电 慢充站', location: ll.LatLng(39.9080, 116.4120), distance: 1200, power: '7kW', available: 20, price: 0.8, isFree: true),
    ChargingStation(name: '小桔充电 免费站', location: ll.LatLng(39.9010, 116.4030), distance: 1500, power: '60kW', available: 4, price: 0.0, isFast: true),
    ChargingStation(name: '云快充 充电站', location: ll.LatLng(39.9100, 116.4080), distance: 900, power: '120kW', available: 6, price: 1.1, isFast: true, is24h: true),
  ];

  ChargingStation? _selectedStation;
  String _selectedFilter = '全部';

  List<ChargingStation> get _filteredStations {
    switch (_selectedFilter) {
      case '快充': return _stations.where((s) => s.isFast).toList();
      case '慢充': return _stations.where((s) => !s.isFast).toList();
      case '免费': return _stations.where((s) => s.isFree).toList();
      case '24小时': return _stations.where((s) => s.is24h).toList();
      default: return _stations;
    }
  }

  void _onMarkerTap(ChargingStation station) {
    setState(() => _selectedStation = station);
    _mapController.move(station.location, 16.0);
  }

  void _onCardTap(ChargingStation station) {
    setState(() => _selectedStation = station);
    _mapController.move(station.location, 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('充电桩地图', style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.my_location, color: AppTheme.primaryGreen),
                    onPressed: () => _mapController.move(ll.LatLng(39.9042, 116.4074), 15.0),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: '搜索充电站...',
                  hintStyle: const TextStyle(color: AppTheme.textHint),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
                  filled: true,
                  fillColor: AppTheme.surfaceDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: ['全部', '快充', '慢充', '免费', '24小时'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(filter, style: TextStyle(color: isSelected ? Colors.white : AppTheme.textSecondary, fontSize: 13)),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedFilter = filter),
                      backgroundColor: AppTheme.surfaceDark,
                      selectedColor: AppTheme.primaryGreen,
                      side: BorderSide.none,
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // Map + Cards
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: ll.LatLng(39.9042, 116.4074),
                      initialZoom: 15.0,
                      onTap: (_, __) => setState(() => _selectedStation = null),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.leaflife.app',
                      ),
                      MarkerLayer(
                        markers: _filteredStations.map((station) {
                          final isSelected = _selectedStation == station;
                          return Marker(
                            point: station.location,
                            width: isSelected ? 50 : 40,
                            height: isSelected ? 50 : 40,
                            child: GestureDetector(
                              onTap: () => _onMarkerTap(station),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryGreen : AppTheme.cardDark,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isSelected ? AppTheme.primaryGreen : Colors.white, width: 2),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))],
                                ),
                                child: Icon(Icons.bolt, color: isSelected ? Colors.white : AppTheme.primaryGreen, size: isSelected ? 28 : 22),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // Gradient overlay
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Colors.transparent, AppTheme.backgroundDark.withOpacity(0.8), AppTheme.backgroundDark],
                        ),
                      ),
                    ),
                  ),

                  // Station Cards
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredStations.length,
                        itemBuilder: (context, index) {
                          final station = _filteredStations[index];
                          final isSelected = _selectedStation == station;
                          return _buildStationCard(station, isSelected);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationCard(ChargingStation station, bool isSelected) {
    return GestureDetector(
      onTap: () => _onCardTap(station),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12, bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen.withOpacity(0.15) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AppTheme.primaryGreen, width: 1.5) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.bolt, color: AppTheme.primaryGreen, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(station.name, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('距您 ${station.distance}m', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('${station.power} | ${station.available}个桩', style: const TextStyle(color: AppTheme.textHint, fontSize: 11)),
                const Spacer(),
                Text(station.isFree ? '免费' : '¥${station.price}/度', style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(color: AppTheme.primaryGreen, borderRadius: BorderRadius.circular(6)),
              child: const Text('导航', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
