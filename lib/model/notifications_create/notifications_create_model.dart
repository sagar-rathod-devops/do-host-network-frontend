class NotificationsCreateModel {
  String message;
  String error;

  NotificationsCreateModel({this.message = '', this.error = ''});

  factory NotificationsCreateModel.fromJson(Map<String, dynamic> json) {
    return NotificationsCreateModel(
      message: json['message'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error};
  }
}
