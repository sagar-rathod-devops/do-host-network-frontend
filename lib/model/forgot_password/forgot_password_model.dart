class ForgotPasswordModel {
  String message;
  String error;

  ForgotPasswordModel({this.message = '', this.error = ''});

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      message: json['message'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
