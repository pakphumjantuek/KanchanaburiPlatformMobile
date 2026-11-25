class ContentScheduleModel {
  final String scheduleId;
  final String title;
  final String? date;
  final String? time;
  final String? location;
  final String? description;

  ContentScheduleModel({
    required this.scheduleId,
    required this.title,
    this.date,
    this.time,
    this.location,
    this.description,
  });

  factory ContentScheduleModel.fromJson(Map<String, dynamic> json) {
    return ContentScheduleModel(
      scheduleId:
          json['scheduleId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'รอบกิจกรรม',
      date: json['date']?.toString() ?? json['startDate']?.toString(),
      time: json['time']?.toString() ?? json['startDateTime']?.toString(),
      location: json['address']?.toString() ?? json['location']?.toString(),
      description: json['description']?.toString(),
    );
  }
}
