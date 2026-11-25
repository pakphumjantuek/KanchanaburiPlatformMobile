class District {
  final String id;
  final String name;

  String get districtId => id;
  String get districtName => name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['districtId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['districtName']?.toString() ?? json['name']?.toString() ?? '',
    );
  }
}

class SubDistrict {
  final String id;
  final String name;

  String get subDistrictId => id;
  String get subDistrictName => name;

  SubDistrict({required this.id, required this.name});

  factory SubDistrict.fromJson(Map<String, dynamic> json) {
    return SubDistrict(
      id: json['subDistrictId']?.toString() ?? json['id']?.toString() ?? '',
      name:
          json['subDistrictName']?.toString() ?? json['name']?.toString() ?? '',
    );
  }
}
