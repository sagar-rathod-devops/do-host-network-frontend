class CountResponseModel {
  final int count;

  CountResponseModel({required this.count});

  factory CountResponseModel.fromJson(Map<String, dynamic> json) {
    return CountResponseModel(count: json['count'] ?? 0);
  }
}

class FollowersResponse {
  final int count;
  final List<String> followers;

  FollowersResponse({required this.count, required this.followers});
}

class FollowingsResponse {
  final int count;
  final List<String> followings;

  FollowingsResponse({required this.count, required this.followings});
}
