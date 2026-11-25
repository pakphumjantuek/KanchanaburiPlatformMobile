class ContentSchedule {
  final String scheduleId;
  final String title;
  final String? startDateTime;
  final String? endDateTime;
  final String? address;
  final String? description;

  ContentSchedule({
    required this.scheduleId,
    required this.title,
    this.startDateTime,
    this.endDateTime,
    this.address,
    this.description,
  });

  factory ContentSchedule.fromJson(Map<String, dynamic> json) {
    return ContentSchedule(
      scheduleId: json['scheduleId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      startDateTime: json['startDateTime']?.toString(),
      endDateTime: json['endDateTime']?.toString(),
      address: json['address']?.toString(),
      description: json['description']?.toString(),
    );
  }
}
