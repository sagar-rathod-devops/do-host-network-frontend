class CountResponseModel {
  final int count;

  CountResponseModel({required this.count});

  factory CountResponseModel.fromJson(Map<String, dynamic> json) {
    return CountResponseModel(count: json['count'] ?? 0);
  }
}
