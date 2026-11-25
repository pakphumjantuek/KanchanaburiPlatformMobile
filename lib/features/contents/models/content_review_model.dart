class ContentReview {
  final String reviewId;
  final String userName;
  final String comment;
  final String? createdAt;
  final double rating;

  ContentReview({
    required this.reviewId,
    required this.userName,
    required this.comment,
    this.createdAt,
    this.rating = 5.0,
  });

  factory ContentReview.fromJson(Map<String, dynamic> json) {
    return ContentReview(
      reviewId: json['reviewId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 'ผู้ใช้งานกาญจนบุรี',
      comment: json['comment']?.toString() ?? '',
      createdAt: json['createdAt']?.toString(),
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
    );
  }
}
