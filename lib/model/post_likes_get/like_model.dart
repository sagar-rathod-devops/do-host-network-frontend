class LikeResponse {
  final List<String> likes;

  LikeResponse({required this.likes});

  factory LikeResponse.fromJson(Map<String, dynamic> json) {
    return LikeResponse(likes: List<String>.from(json['likes'] ?? []));
  }

  Map<String, dynamic> toJson() {
    return {'likes': likes};
  }
}
