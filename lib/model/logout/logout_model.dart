class LogoutModel {
  String message;
  String error;

  LogoutModel({this.message = '', this.error = ''});

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      message: json['message'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
