class UserFollowModel {
  final String message;
  final String error;

  UserFollowModel({this.message = '', this.error = ''});

  factory UserFollowModel.fromJson(Map<String, dynamic> json) {
    return UserFollowModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
