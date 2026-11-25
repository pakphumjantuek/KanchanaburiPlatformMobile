class ShopReviewModel {
  final String id;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final bool isVerifiedBuyer;
  final String? ownerReply;
  final DateTime? ownerReplyAt;

  ShopReviewModel({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.isVerifiedBuyer = true,
    this.ownerReply,
    this.ownerReplyAt,
  });

  factory ShopReviewModel.fromJson(Map<String, dynamic> json) {
    return ShopReviewModel(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 'ผู้ใช้งานทั่วไป',
      userAvatar: json['userAvatar']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      isVerifiedBuyer: json['isVerifiedBuyer'] ?? true,
      ownerReply: json['ownerReply']?.toString(),
      ownerReplyAt: json['ownerReplyAt'] != null
          ? DateTime.parse(json['ownerReplyAt'].toString())
          : null,
    );
  }
}
