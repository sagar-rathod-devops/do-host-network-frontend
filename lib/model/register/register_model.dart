class RegisterModel {
  final String message;
  final String error;

  RegisterModel({this.message = '', this.error = ''});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
