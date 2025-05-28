class PostJobModel {
  final String message;
  final String error;

  PostJobModel({this.message = '', this.error = ''});

  factory PostJobModel.fromJson(Map<String, dynamic> json) {
    return PostJobModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
