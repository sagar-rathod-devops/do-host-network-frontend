class FollowingResponse {
  final List<String> followings;

  FollowingResponse({required this.followings});

  factory FollowingResponse.fromJson(Map<String, dynamic> json) {
    return FollowingResponse(
      followings: List<String>.from(json['followings'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'followings': followings};
  }
}
