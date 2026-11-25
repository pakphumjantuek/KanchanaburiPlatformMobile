class UserAddressModel {
  final String? userAddressId;
  final String recipientName;
  final String recipientPhone;
  final String addressLine;
  final String? subDistrict;
  final String? district;
  final String? province;
  final String? postalCode;
  final bool isDefault;

  UserAddressModel({
    this.userAddressId,
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine,
    this.subDistrict,
    this.district,
    this.province = 'กาญจนบุรี',
    this.postalCode,
    this.isDefault = false,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      userAddressId: json['userAddressId']?.toString(),
      recipientName: json['recipientName']?.toString() ?? '',
      recipientPhone: json['recipientPhone']?.toString() ?? '',
      addressLine: json['addressLine']?.toString() ?? '',
      subDistrict: json['subDistrict']?.toString(),
      district: json['district']?.toString(),
      province: json['province']?.toString() ?? 'กาญจนบุรี',
      postalCode: json['postalCode']?.toString(),
      isDefault: json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userAddressId != null) 'userAddressId': userAddressId,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'addressLine': addressLine,
      'subDistrict': subDistrict,
      'district': district,
      'province': province,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }

  String get fullAddress {
    final parts = <String>[
      addressLine,
      if (subDistrict != null && subDistrict!.isNotEmpty) 'ต.$subDistrict',
      if (district != null && district!.isNotEmpty) 'อ.$district',
      if (province != null && province!.isNotEmpty) 'จ.$province',
      if (postalCode != null && postalCode!.isNotEmpty) postalCode!,
    ];
    return parts.join(' ');
  }
}
