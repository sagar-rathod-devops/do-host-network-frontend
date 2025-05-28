class PostLikeModel {
  final String message;
  final String error;

  PostLikeModel({this.message = '', this.error = ''});

  factory PostLikeModel.fromJson(Map<String, dynamic> json) {
    return PostLikeModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
