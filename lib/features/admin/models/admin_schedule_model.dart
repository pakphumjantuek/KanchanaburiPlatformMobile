class AdminSchedule {
  final String scheduleId;
  final String contentId;
  final String? contentTitle;
  final String title;
  final String startDateTime;
  final String? endDateTime;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String status; // 'Active' | 'Inactive' | 'Cancelled'
  final String createdAt;

  AdminSchedule({
    required this.scheduleId,
    required this.contentId,
    this.contentTitle,
    required this.title,
    required this.startDateTime,
    this.endDateTime,
    this.address,
    this.latitude,
    this.longitude,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory AdminSchedule.fromJson(Map<String, dynamic> json) {
    return AdminSchedule(
      scheduleId: json['scheduleId'] as String? ?? '',
      contentId: json['contentId'] as String? ?? '',
      contentTitle: json['contentTitle'] as String?,
      title: json['title'] as String? ?? '',
      startDateTime: json['startDateTime'] as String? ?? '',
      endDateTime: json['endDateTime'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'Active',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

class ScheduleFormData {
  final String? contentId;
  final String title;
  final String startDateTime;
  final String? endDateTime;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? status;

  ScheduleFormData({
    this.contentId,
    required this.title,
    required this.startDateTime,
    this.endDateTime,
    this.address,
    this.latitude,
    this.longitude,
    this.description,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'contentId': contentId,
      'title': title,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      if (status != null) 'status': status,
    };
  }
}
