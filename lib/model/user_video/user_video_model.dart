class UserVideoModel {
  final String message;
  final String error;

  UserVideoModel({this.message = '', this.error = ''});

  factory UserVideoModel.fromJson(Map<String, dynamic> json) {
    return UserVideoModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
