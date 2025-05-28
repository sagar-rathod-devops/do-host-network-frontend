class VerifyOTPModel {
  final String message;
  final String error;

  VerifyOTPModel({required this.message, required this.error});

  factory VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    return VerifyOTPModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
