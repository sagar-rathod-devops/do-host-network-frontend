class PostContentModel {
  final String message;
  final String error;

  PostContentModel({this.message = '', this.error = ''});

  factory PostContentModel.fromJson(Map<String, dynamic> json) {
    return PostContentModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
