class UserUnfollowModel {
  final String message;
  final String error;

  UserUnfollowModel({this.message = '', this.error = ''});

  factory UserUnfollowModel.fromJson(Map<String, dynamic> json) {
    return UserUnfollowModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
