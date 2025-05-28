class PostCommentModel {
  final String message;
  final String error;

  PostCommentModel({this.message = '', this.error = ''});

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(
      message: json['message'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
