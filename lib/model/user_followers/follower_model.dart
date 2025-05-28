class FollowerResponse {
  final List<String> followers;

  FollowerResponse({required this.followers});

  factory FollowerResponse.fromJson(Map<String, dynamic> json) {
    return FollowerResponse(
      followers: List<String>.from(json['followers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'followers': followers};
  }
}
