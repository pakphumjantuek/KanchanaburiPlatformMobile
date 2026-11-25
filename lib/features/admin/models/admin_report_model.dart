class AdminReport {
  final String reportId;
  final String? contentId;
  final String? reviewId;
  final String targetLabel;
  final String reason;
  final String? description;
  final String status; // 'Pending' | 'InProgress' | 'Resolved' | 'Dismissed'
  final String createdAt;

  AdminReport({
    required this.reportId,
    this.contentId,
    this.reviewId,
    required this.targetLabel,
    required this.reason,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory AdminReport.fromJson(Map<String, dynamic> json) {
    return AdminReport(
      reportId: json['reportId'] as String? ?? '',
      contentId: json['contentId'] as String?,
      reviewId: json['reviewId'] as String?,
      targetLabel: json['targetLabel'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'Pending',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
