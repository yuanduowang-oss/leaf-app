import '../models/ev_car.dart';

/// 24款热门新能源车型 Mock 数据，覆盖中美欧主流品牌
class MockCars {
  static final List<EvCar> cars = [
    // ===== Tesla (4) =====
    EvCar(id: 'tesla-model3', brand: 'Tesla', model: 'Model 3', fullName: 'Tesla Model 3',
      imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=400',
      priceRange: '\$38,990', category: 'Sedan',
      specs: EvCarSpecs(rangeKm: 606, batteryKwh: 60, chargingTimeH: 0.42, accelerationS: 6.1,
        powerKw: 208, torqueNm: 375, driveType: 'RWD', batteryType: 'LFP',
        autonomousLevel: 'L2+', seats: 5, length: 4720, width: 1848, height: 1441,
        wheelbase: 2875, chargePort: 'NACS', hasHUD: false, hasAirSuspension: false,
        hasHeatPump: true, speakerCount: 14, seatVentilation: 'Front', trunkL: 594,
        topSpeed: 225, chipBrand: 'FSD HW4', chipTops: 144)),
    EvCar(id: 'tesla-modely', brand: 'Tesla', model: 'Model Y', fullName: 'Tesla Model Y',
      imageUrl: 'https://images.unsplash.com/photo-1621954915653-cd9f4f2f7a03?w=400',
      priceRange: '\$44,990', category: 'SUV',
      specs: EvCarSpecs(rangeKm: 660, batteryKwh: 75, chargingTimeH: 0.45, accelerationS: 5.0,
        powerKw: 283, torqueNm: 440, driveType: 'AWD', batteryType: 'LFP',
        autonomousLevel: 'L2+', seats: 5, length: 4751, width: 1921, height: 1624,
        wheelbase: 2890, chargePort: 'NACS', hasHUD: false, hasAirSuspension: false,
        hasHeatPump: true, speakerCount: 14, seatVentilation: 'Front', trunkL: 854,
        topSpeed: 217, chipBrand: 'FSD HW4', chipTops: 144)),
    EvCar(id: 'tesla-models', brand: 'Tesla', model: 'Model S', fullName: 'Tesla Model S Plaid',
      imageUrl: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=400',
      priceRange: '\$89,990', category: 'Sedan',
      specs: EvCarSpecs(rangeKm: 637, batteryKwh: 100, chargingTimeH: 0.33, accelerationS: 2.1,
        powerKw: 760, torqueNm: 1420, driveType: 'AWD', batteryType: 'NCM',
        autonomousLevel: 'L2+', seats: 5, length: 5021, width: 1987, height: 1431,
        wheelbase: 2960, chargePort: 'NACS', hasHUD: true, hasAirSuspension: true,
        hasHeatPump: true, speakerCount: 22, seatVentilation: 'All', trunkL: 793,
        topSpeed: 322, chipBrand: 'FSD HW4', chipTops: 144)),
    EvCar(id: 'tesla-modelx', brand: 'Tesla', model: 'Model X', fullName: 'Tesla Model X',
      imageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400',
      priceRange: '\$79,990', category: 'SUV',
      specs: EvCarSpecs(rangeKm: 560, batteryKwh: 100, chargingTimeH: 0.5, accelerationS: 2.6,
        powerKw: 760, torqueNm: 1140, driveType: 'AWD', batteryType: 'NCM',
        autonomousLevel: 'L2+', seats: 7, length: 5057, width: 1999, height: 1680,
        wheelbase: 2965, chargePort: 'NACS', hasHUD: true, hasAirSuspension: true,
        hasHeatPump: true, speakerCount: 22, seatVentilation: 'All', trunkL: 2614,
        topSpeed: 262, chipBrand: 'FSD HW4', chipTops: 144)),
    // ===== BYD (3) =====
    EvCar(id: 'byd-hanev', brand: 'BYD', model: 'Han EV', fullName: 'BYD Han EV',
      imageUrl: 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=400',
      priceRange: 'CNY 229,800', category: 'Sedan',
      specs: EvCarSpecs(rangeKm: 605, batteryKwh: 85.4, chargingTimeH: 0.42, accelerationS: 7.9,
        powerKw: 180, torqueNm: 350, driveType: 'FWD', batteryType: 'LFP (Blade)',
        autonomousLevel: 'L2', seats: 5, length: 4995, width: 1910, height: 1495,
        wheelbase: 2920, chargePort: 'GB/T', hasHUD: false, hasAirSuspension: false,
        hasHeatPump: true, speakerCount: 12, seatVentilation: 'Front', trunkL: 470,
        topSpeed: 185, chipBrand: 'Horizon J5', chipTops: 128)),
    EvCar(id: 'byd-seal', brand: 'BYD', model: 'Seal', fullName: 'BYD Seal',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      priceRange: 'CNY 189,800', category: 'Sedan',
      specs: EvCarSpecs(rangeKm: 700, batteryKwh: 82.5, chargingTimeH: 0.5, accelerationS: 3.8,
        powerKw: 390, torqueNm: 670, driveType: 'AWD', batteryType: 'LFP (Blade)',
        autonomousLevel: 'L2', seats: 5, length: 4800, width: 1875, height: 1460,
        wheelbase: 2920, chargePort: 'GB/T', hasHUD: true, hasAirSuspension: false,
        hasHeatPump: true, speakerCount: 12, seatVentilation: 'Front', trunkL: 400,
        topSpeed: 180, chipBrand: 'Horizon J5', chipTops: 128)),
    EvCar(id: 'byd-atto3', brand: 'BYD', model: 'Atto 3', fullName: 'BYD Atto 3',
      imageUrl: 'https://images.unsplash.com/photo-1525609004556-c46c7d6cf023?w=400',
      priceRange: '\$38,000', category: 'SUV',
      specs: EvCarSpecs(rangeKm: 420, batteryKwh: 49.9, chargingTimeH: 0.5, accelerationS: 7.3,
        powerKw: 150, torqueNm: 310, driveType: 'FWD', batteryType: 'LFP (Blade)',
        autonomousLevel: 'L2', seats: 5, length: 4455, width: 1875, height: 1615,
        wheelbase: 2720, chargePort: 'CCS', hasHUD: false, hasAirSuspension: false,
        hasHeatPump: true, speakerCount: 6, seatVentilation: 'None', trunkL: 440,
        topSpeed: 160, chipBrand: 'Horizon J3', chipTops: 5)),
    // ===== NIO (2) =====
    EvCar(id: 'nio-et7', brand: 'NIO', model: 'ET7', fullName: 'NIO ET7',
      imageUrl: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=400',
      priceRange: 'CNY 458,000', category: 'Sedan',
      specs: EvCarSpecs(rangeKm: 580, batteryKwh: 100, chargingTimeH: 0.6, accelerationS: 3.8,
        powerKw: 480, torqueNm: 850, driveType: 'AWD', batteryType: 'NCM',
        autonomousLevel: 'L3', seats: 5, length: 5101, width: 1987, height: 1509,
        wheelbase: 3060, chargePort: 'GB/T+CCS', hasHUD: true, hasAirSuspension: true,
        hasHeatPump: true, speakerCount: 23, seatVentilation: 'All', trunkL: 503,
        topSpeed: 200, chipBrand: 'Orin X x4', chipTops: 1016)),
    EvCar(id: 'nio-es6', brand: 'NIO', model: 'ES6', fullName: 'NIO ES6',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      priceRange: 'CNY 338,000', category: 'SUV',
      specs: EvCarSpecs(rangeKm: 490, batteryKwh: 75, chargingTimeH: 0.5, accelerationS: 4.5,
        powerKw: 360, torqueNm: 700, driveType: 'AWD', batteryType: 'NCM',
        autonomousLevel: 'L3', seats: 5, length: 4854, width: 1995, height: 1703,
        wheelbase: 2915, chargePort: 'GB/T+CCS', hasHUD: true, hasAirSuspension: true,
        hasHeatPump: true, speakerCount: 23, seatVentilation: 'All', trunkL: 579,
        topSpeed: 200, chipBrand: 'Orin X x4', chipTops: 1016)),
    // ===== XPeng (2) =====
    EvCar(id: 'xpeng-p7', brand: 'XPeng', model: 'P7', fullName: 'XPeng P7',
      imageUrl: 'https://images.unsplash.com/photo-1619767886558-efdc7b9e0473?w=400',
      priceRange: 'CNY 209,900', category: 'Sedan',
      specs: EvCarSpecs(rangeKm: 706, batteryKwh: 86.2, chargingTimeH: 0.45, accelerationS: 4.3,
        powerKw: 316, torqueNm: 655, driveType: 'AWD', batteryType: 'NCM',
        autonomousLevel: 'L2+', seats: 5, length: 4888, width: 1896, height: 1450,
        wheelbase: 2998, chargePort: 'GB/T', hasHUD: false, hasAirSuspension: false,
        hasHeatPump: true, speakerCount: 18, seatVentilation: 'Front', trunkL: 440,
        topSpeed: 170, chipBrand: 'Orin X x2', chipTops: 508)),
    EvCar(id: 'xpeng-g9', brand: 'XPeng', model: 'G9', fullName: 'XPeng G9',
      imageUrl: 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=400',
      priceRange: 'CNY 263,900', category: 'SUV',
      specs: EvCarSpecs(rangeKm: 702, batteryKwh: 98, chargingTimeH: 0.27, accelerationS: 3.9,
        powerKw: 405, torqueNm: 717, driveType: 'AWD', batteryType: 'NCM',
        autonomousLevel: 'L2+', seats: 5, length: 4891, width: 1937, height: 1670,
        wheelbase: 2998, chargePort: 'GB/T', hasHUD: true, hasAirSuspension: true,
        hasHeatPump: true, speakerCount: 22, seatVentilation: 'All', trunkL: 660,
        topSpeed: 200, chipBrand: 'Orin X x2', chipTops: 508)),
    // ===== Li Auto =====
    EvCar(id: 'li-l7', brand: 'Li Auto', model: 'L7', fullName: 'Li Auto L7',
      imageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400',
      priceRange: 'CNY 319,800', category: 'SUV',
      specs: EvCarSpecs(rangeKm: 210, batteryKwh: 42.8, chargingTimeH: 0.5, accelerationS: 5.3,
        powerKw: 330, torqueNm: 620, driveType: 'AWD', batteryType: 'NCM (EREV)',
        autonomousLevel: 'L2+', seats: 5, length: 5050, width: 1995, height: 1750,
        wheelbase: 3005, chargePort: 'GB/T', hasHUD: true, hasAirSuspension: true,
        hasHeatPump: true, speakerCount: 19, seatVentilation: 'All', trunkL: 801,
        topSpeed: 180, chipBrand: 'Horizon J5 x2', chipTops: 256)),
    // ===== Zeekr =====
    EvCar(id: 'zeekr-001', brand: 'Zeekr', model: '001', fullName: 'Zeekr 001',
      imageUrl: 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=400',
      priceRange: 'CNY 269,000', category: 'Sedan',
      specs: EvCarSpecs(rangeKm: 741, batteryKwh: 100, chargingTimeH: 0.5, accelerationS: 3.8,
        powerKw: 400, torqueNm: 686, driveType: 'AWD', batteryType: 'NCM',
        autonomousLevel: 'L2+', seats: 5, length: 4970, width: 1999, height: 1560,
        wheelbase: 3005, chargePort: 'GB/T', hasHUD: true, hasAirSuspension: true,
        hasHeatPump: true, speakerCount: 12, seatVentilation: 'All', trunkL: 539,
        topSpeed: 200, chipBrand: 'Mobileye EQ5 x2', chipTops: 48)),
    // ===== Xiaomi =====
    EvCar(id: 'xiaomi-su7', brand: 'Xiaomi', model: 'SU7', fullName: 'Xiaomi SU7 Max',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      priceRange: 'CNY 215,900', category: 'Sedan',
      specs: EvCarSpecs(rangeKm: 830, batteryKwh: 101, chargingTimeH: 0.33, accelerationS: 2.78,
        powerKw: 495, torqueNm: 838, driveType: 'AWD', batteryType: 'NCM',
        autonomousLevel: 'L2+', seats: 5, length: 4997, width: 1963, height: 1455,
        wheelbase: 3000, chargePort: 'GB/T', hasHUD: true, hasAirSuspension: true,
        hasHeatPump: true, speakerCount: 25, seatVentilation: 'All', trunkL: 517,
        topSpeed: 265, chipBrand: 'Orin X x2', chipTops: 508)),
  ];

  static List<EvCar> getCars({String? category, String? searchQuery}) {
    var result = List<EvCar>.from(cars);
    if (category != null && category != 'All') {
      result = result.where((c) => c.category == category).toList();
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((c) =>
        c.fullName.toLowerCase().contains(q) ||
        c.brand.toLowerCase().contains(q)
      ).toList();
    }
    return result;
  }

  static EvCar? getCarById(String id) {
    try {
      return cars.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<String> get categories => ['All', 'Sedan', 'SUV', 'MPV', 'Sports'];

  static List<String> get brands =>
      cars.map((c) => c.brand).toSet().toList()..sort();
}