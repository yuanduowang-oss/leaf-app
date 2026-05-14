/// EV 车型数据模型 - 用于车型对比
class EvCar {
  final String id;
  final String brand;         // 品牌
  final String model;         // 型号
  final String fullName;      // 全称 (brand + model)
  final String imageUrl;      // 车型图片
  final String priceRange;    // 价格区间
  final String category;      // 类型: 轿车/SUV/MPV/跑车
  final EvCarSpecs specs;

  const EvCar({
    required this.id,
    required this.brand,
    required this.model,
    required this.fullName,
    required this.imageUrl,
    required this.priceRange,
    required this.category,
    required this.specs,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'model': model,
    'fullName': fullName,
    'imageUrl': imageUrl,
    'priceRange': priceRange,
    'category': category,
    'specs': specs.toJson(),
  };
}

/// 车型详细参数
class EvCarSpecs {
  final double rangeKm;           // 续航 (km) - NEDC/CLTC
  final double batteryKwh;        // 电池容量 (kWh)
  final double chargingTimeH;     // 快充时间 30%-80% (小时)
  final double accelerationS;     // 0-100km/h 加速 (秒)
  final double powerKw;           // 电机功率 (kW)
  final double torqueNm;          // 扭矩 (Nm)
  final String driveType;         // 驱动: 前驱/后驱/四驱
  final String batteryType;       // 电池类型: 三元锂/磷酸铁锂
  final String autonomousLevel;   // 辅助驾驶: L2/L2+/L3
  final int seats;                // 座位数
  final double length;            // 车长 (mm)
  final double width;             // 车宽 (mm)
  final double height;            // 车高 (mm)
  final double wheelbase;         // 轴距 (mm)
  final String chargePort;        // 充电口: 国标/CCS/特斯拉
  final bool hasHUD;              // HUD抬头显示
  final bool hasAirSuspension;    // 空气悬架
  final bool hasHeatPump;         // 热泵空调
  final int speakerCount;         // 音响数量
  final String seatVentilation;   // 座椅通风: 无/前排/全车
  final double trunkL;            // 后备箱容积 (L)
  final double topSpeed;          // 最高时速 (km/h)
  final String chipBrand;         // 智驾芯片
  final double chipTops;          // 芯片算力 (TOPS)

  const EvCarSpecs({
    required this.rangeKm,
    required this.batteryKwh,
    required this.chargingTimeH,
    required this.accelerationS,
    required this.powerKw,
    required this.torqueNm,
    required this.driveType,
    required this.batteryType,
    required this.autonomousLevel,
    required this.seats,
    required this.length,
    required this.width,
    required this.height,
    required this.wheelbase,
    required this.chargePort,
    this.hasHUD = false,
    this.hasAirSuspension = false,
    this.hasHeatPump = false,
    this.speakerCount = 6,
    this.seatVentilation = '无',
    this.trunkL = 400,
    this.topSpeed = 160,
    this.chipBrand = 'Mobileye',
    this.chipTops = 2.5,
  });

  Map<String, dynamic> toJson() => {
    'rangeKm': rangeKm,
    'batteryKwh': batteryKwh,
    'chargingTimeH': chargingTimeH,
    'accelerationS': accelerationS,
    'powerKw': powerKw,
    'torqueNm': torqueNm,
    'driveType': driveType,
    'batteryType': batteryType,
    'autonomousLevel': autonomousLevel,
    'seats': seats,
    'length': length,
    'width': width,
    'height': height,
    'wheelbase': wheelbase,
    'chargePort': chargePort,
    'hasHUD': hasHUD,
    'hasAirSuspension': hasAirSuspension,
    'hasHeatPump': hasHeatPump,
    'speakerCount': speakerCount,
    'seatVentilation': seatVentilation,
    'trunkL': trunkL,
    'topSpeed': topSpeed,
    'chipBrand': chipBrand,
    'chipTops': chipTops,
  };
}
