class PostUnlikeModel {
  final String message;
  final String error;

  PostUnlikeModel({this.message = '', this.error = ''});

  factory PostUnlikeModel.fromJson(Map<String, dynamic> json) {
    return PostUnlikeModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
