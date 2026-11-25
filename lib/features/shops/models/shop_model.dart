import '../../../../app/config/api_config.dart';

class ShopModel {
  final String id;
  final String? shopCategoryId;
  final String? categoryName;
  final String? districtId;
  final String? districtName;
  final String? subDistrictId;
  final String? subDistrictName;
  final String name;
  final String? description;
  final String? phone;
  final String? email;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String status;
  final String? coverImageUrl;
  final String? backgroundImageUrl;
  final String? openingTime;
  final String? closingTime;
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? promptPay;

  String get shopId => id;
  String get shopName => name;

  ShopModel({
    required this.id,
    this.shopCategoryId,
    this.categoryName,
    this.districtId,
    this.districtName,
    this.subDistrictId,
    this.subDistrictName,
    required this.name,
    this.description,
    this.phone,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.status = 'Active',
    this.coverImageUrl,
    this.backgroundImageUrl,
    this.openingTime,
    this.closingTime,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.promptPay,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    double? parseCoord(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    String? resolveUrl(dynamic val) {
      if (val == null) return null;
      String str = val.toString();
      if (str.startsWith('/uploads')) {
        return ApiConfig.baseUrl.replaceAll('/api', '') + str;
      }
      return str;
    }

    return ShopModel(
      id: json['shopId']?.toString() ?? json['id']?.toString() ?? '',
      shopCategoryId: json['shopCategoryId']?.toString(),
      categoryName:
          json['categoryName']?.toString() ??
          json['category']?['categoryName']?.toString(),
      districtId: json['districtId']?.toString(),
      districtName:
          json['districtName']?.toString() ??
          json['district']?['districtName']?.toString(),
      subDistrictId: json['subDistrictId']?.toString(),
      subDistrictName:
          json['subDistrictName']?.toString() ??
          json['subDistrict']?['subDistrictName']?.toString(),
      name:
          json['shopName']?.toString() ??
          json['name']?.toString() ??
          'ไม่มีชื่อร้านค้า',
      description: json['description']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      latitude: parseCoord(json['latitude']),
      longitude: parseCoord(json['longitude']),
      status: json['status']?.toString() ?? 'Active',
      coverImageUrl: resolveUrl(json['coverImageUrl']),
      backgroundImageUrl: resolveUrl(json['backgroundImageUrl']),
      openingTime: json['openingTime']?.toString(),
      closingTime: json['closingTime']?.toString(),
      bankName: json['bankName']?.toString(),
      bankAccountName: json['bankAccountName']?.toString(),
      bankAccountNumber: json['bankAccountNumber']?.toString(),
      promptPay: json['promptPay']?.toString(),
    );
  }

  bool get isOpenNow {
    if (openingTime == null || closingTime == null) return true;
    try {
      final now = DateTime.now();
      final openParts = openingTime!.split(':');
      final closeParts = closingTime!.split(':');
      if (openParts.length < 2 || closeParts.length < 2) return true;

      final openMinutes =
          int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
      final closeMinutes =
          int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);
      final currentMinutes = now.hour * 60 + now.minute;

      if (closeMinutes > openMinutes) {
        return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
      } else {
        // Overnight opening (e.g. 18:00 - 02:00)
        return currentMinutes >= openMinutes || currentMinutes <= closeMinutes;
      }
    } catch (_) {
      return true;
    }
  }
}
