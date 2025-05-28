class UserVideoResponse {
  final String id;
  final String userId;
  final String videoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserVideoResponse({
    required this.id,
    required this.userId,
    required this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserVideoResponse.fromJson(Map<String, dynamic> json) {
    return UserVideoResponse(
      id: json['id'],
      userId: json['user_id'],
      videoUrl: json['video_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'video_url': videoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
