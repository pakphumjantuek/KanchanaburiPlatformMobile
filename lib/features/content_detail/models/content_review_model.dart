class ContentReviewModel {
  final String reviewId;
  final String? userId;
  final String userName;
  final String? userAvatar;
  final String comment;
  final double rating;
  final String? createdAt;
  final bool isMine;

  ContentReviewModel({
    required this.reviewId,
    this.userId,
    required this.userName,
    this.userAvatar,
    required this.comment,
    this.rating = 5.0,
    this.createdAt,
    this.isMine = false,
  });

  factory ContentReviewModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final uId =
        json['userId']?.toString() ?? json['createdByUserId']?.toString();
    return ContentReviewModel(
      reviewId: json['reviewId']?.toString() ?? json['id']?.toString() ?? '',
      userId: uId,
      userName:
          json['userName']?.toString() ??
          json['user']?['name']?.toString() ??
          'ผู้ใช้งานกาญจนบุรี',
      userAvatar:
          json['userAvatar']?.toString() ?? json['avatarUrl']?.toString(),
      comment: json['comment']?.toString() ?? json['text']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
      createdAt: json['createdAt']?.toString() ?? json['date']?.toString(),
      isMine:
          json['isMine'] == true ||
          (currentUserId != null && uId == currentUserId),
    );
  }
}
