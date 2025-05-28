class UserExperienceModel {
  final String message;
  final String error;

  UserExperienceModel({this.message = '', this.error = ''});

  factory UserExperienceModel.fromJson(Map<String, dynamic> json) {
    return UserExperienceModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
