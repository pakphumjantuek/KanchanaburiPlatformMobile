class AdminTag {
  final String tagId;
  final String tagName;
  final String status; // 'Active' | 'Inactive'

  AdminTag({
    required this.tagId,
    required this.tagName,
    required this.status,
  });

  factory AdminTag.fromJson(Map<String, dynamic> json) {
    return AdminTag(
      tagId: json['tagId'] as String? ?? '',
      tagName: json['tagName'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'tagName': tagName,
      'status': status,
    };
  }
}
