class UserEducationModel {
  final String message;
  final String error;

  UserEducationModel({this.message = '', this.error = ''});

  factory UserEducationModel.fromJson(Map<String, dynamic> json) {
    return UserEducationModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
