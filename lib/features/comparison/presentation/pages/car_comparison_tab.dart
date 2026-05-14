import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ev_car.dart';
import '../../../../data/mock/mock_cars.dart';

class CarComparisonTab extends StatefulWidget {
  const CarComparisonTab({super.key});

  @override
  State<CarComparisonTab> createState() => _CarComparisonTabState();
}

class _CarComparisonTabState extends State<CarComparisonTab> {
  final List<EvCar> _selectedCars = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final default1 = MockCars.getCarById('tesla-modely');
    final default2 = MockCars.getCarById('xiaomi-su7');
    if (default1 != null) _selectedCars.add(default1);
    if (default2 != null) _selectedCars.add(default2);
  }

  void _addCar(EvCar car) {
    if (_selectedCars.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Max 4 cars'), backgroundColor: AppTheme.surfaceDark),
      );
      return;
    }
    if (_selectedCars.any((c) => c.id == car.id)) return;
    setState(() => _selectedCars.add(car));
  }

  void _removeCar(String carId) {
    if (_selectedCars.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keep at least 1'), backgroundColor: AppTheme.surfaceDark),
      );
      return;
    }
    setState(() => _selectedCars.removeWhere((c) => c.id == carId));
  }

  void _showCarPicker() {
    final available = MockCars.cars.where((c) =>
      !_selectedCars.any((s) => s.id == c.id) &&
      (c.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
       c.brand.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return DraggableScrollableSheet(
            expand: false, initialChildSize: 0.75, maxChildSize: 0.95, minChildSize: 0.5,
            builder: (ctx, scrollController) {
              return Column(children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textHint, borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search EV models...',
                      hintStyle: const TextStyle(color: AppTheme.textHint),
                      prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
                      suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppTheme.textHint),
                            onPressed: () => setSheetState(() => _searchQuery = ''))
                        : null,
                      filled: true, fillColor: AppTheme.surfaceDark,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onChanged: (v) => setSheetState(() => _searchQuery = v),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(height: 36, child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', 'Sedan', 'SUV'].map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat, style: const TextStyle(fontSize: 12)),
                        selected: false,
                        onSelected: (_) => setSheetState(() {
                          _searchQuery = cat == 'All' ? '' : cat;
                        }),
                        backgroundColor: AppTheme.surfaceDark,
                        selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.primaryGreen,
                        labelStyle: const TextStyle(color: AppTheme.textSecondary),
                        side: BorderSide.none,
                      ),
                    )).toList(),
                  )),
                ),
                const Divider(color: AppTheme.cardDark, height: 1),
                Expanded(
                  child: available.isEmpty
                    ? const Center(child: Text('No matching models',
                        style: TextStyle(color: AppTheme.textHint)))
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: available.length,
                        separatorBuilder: (_, __) =>
                          const Divider(color: AppTheme.cardDark, height: 1),
                        itemBuilder: (ctx, i) {
                          final car = available[i];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(car.imageUrl, width: 56, height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 56, height: 40, color: AppTheme.surfaceDark,
                                  child: const Icon(Icons.directions_car,
                                    color: AppTheme.textHint, size: 24))),
                            ),
                            title: Text(car.fullName, style: const TextStyle(
                              color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                            subtitle: Text('${car.priceRange}  ${car.specs.rangeKm.toInt()}km',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            trailing: const Icon(Icons.add_circle_outline,
                              color: AppTheme.primaryGreen),
                            onTap: () { _addCar(car); Navigator.pop(ctx); },
                          );
                        }),
                ),
              ]);
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(children: [
              const Text('EV Comparison', style: TextStyle(
                color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                onPressed: _selectedCars.length < 4 ? _showCarPicker : null,
                icon: const Icon(Icons.add, color: AppTheme.primaryGreen),
                label: const Text('Add Car',
                  style: TextStyle(color: AppTheme.primaryGreen)),
              ),
            ]),
          ),
          // Selected cars header
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _selectedCars.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (ctx, i) => _carCard(_selectedCars[i]),
            ),
          ),
          const Divider(color: AppTheme.cardDark, height: 1),
          // Comparison table
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _section('Performance'),
                _row('Range (km)', (c) => '${c.specs.rangeKm.toInt()}km'),
                _row('0-100km/h', (c) => '${c.specs.accelerationS}s'),
                _row('Top Speed', (c) => '${c.specs.topSpeed.toInt()}km/h'),
                _row('Power', (c) => '${c.specs.powerKw.toInt()}kW'),
                _row('Torque', (c) => '${c.specs.torqueNm.toInt()}Nm'),
                _row('Drive', (c) => c.specs.driveType),
                const SizedBox(height: 16),
                _section('Battery & Charging'),
                _row('Battery', (c) => '${c.specs.batteryKwh}kWh'),
                _row('Type', (c) => c.specs.batteryType),
                _row('Fast Charge', (c) => '${(c.specs.chargingTimeH * 60).toInt()}min'),
                _row('Port', (c) => c.specs.chargePort),
                const SizedBox(height: 16),
                _section('Dimensions'),
                _row('Length', (c) => '${c.specs.length.toInt()}mm'),
                _row('Width', (c) => '${c.specs.width.toInt()}mm'),
                _row('Height', (c) => '${c.specs.height.toInt()}mm'),
                _row('Wheelbase', (c) => '${c.specs.wheelbase.toInt()}mm'),
                _row('Trunk', (c) => '${c.specs.trunkL.toInt()}L'),
                const SizedBox(height: 16),
                _section('Features'),
                _row('ADAS', (c) => c.specs.autonomousLevel),
                _row('Chip', (c) => c.specs.chipBrand),
                _row('TOPS', (c) => '${c.specs.chipTops.toInt()}'),
                _row('HUD', (c) => c.specs.hasHUD ? '\u2713' : '\u2717'),
                _row('Air Susp', (c) => c.specs.hasAirSuspension ? '\u2713' : '\u2717'),
                _row('Heat Pump', (c) => c.specs.hasHeatPump ? '\u2713' : '\u2717'),
                _row('Speakers', (c) => '${c.specs.speakerCount}'),
                _row('Seat Vent', (c) => c.specs.seatVentilation),
                const SizedBox(height: 80),
              ]),
            ),
          ),
          // Bottom bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              border: Border(top: BorderSide(color: AppTheme.cardDark)),
            ),
            child: Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _share,
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primaryGreen),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    foregroundColor: AppTheme.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _testDrive,
                  icon: const Icon(Icons.drive_eta, size: 18),
                  label: const Text('Test Drive'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _carCard(EvCar car) {
    return GestureDetector(
      onLongPress: () => _removeCar(car.id),
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surfaceDark),
        ),
        child: Column(children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(children: [
              Image.network(car.imageUrl, height: 70, width: 110, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 70, color: AppTheme.surfaceDark,
                  child: const Icon(Icons.directions_car, color: AppTheme.textHint, size: 32))),
              Positioned(top: 4, right: 4,
                child: GestureDetector(
                  onTap: () => _removeCar(car.id),
                  child: Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: Colors.black54, borderRadius: BorderRadius.circular(11)),
                    child: const Icon(Icons.close, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(car.fullName,
                style: const TextStyle(
                  color: AppTheme.textPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(car.priceRange,
                style: TextStyle(
                  color: AppTheme.primaryGreen, fontSize: 10, fontWeight: FontWeight.bold)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(
        color: AppTheme.primaryGreen, fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  Widget _row(String label, String Function(EvCar) getValue) {
    final values = _selectedCars.map((c) => getValue(c)).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        SizedBox(width: 90,
          child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))),
        ..._selectedCars.asMap().entries.map((entry) {
          return Expanded(
            child: Text(values[entry.key],
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
              textAlign: TextAlign.center),
          );
        }),
      ]),
    );
  }

  void _share() {
    final names = _selectedCars.map((c) => c.fullName).join(' vs ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Shared: $names'), backgroundColor: AppTheme.primaryGreen),
    );
  }

  void _testDrive() {
    final names = _selectedCars.map((c) => c.fullName).join(', ');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('Book Test Drive', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text('Schedule test drives for:\n$names\n\nDealer will contact you.',
          style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
