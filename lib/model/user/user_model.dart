class UserModel {
  final String token;
  final String userID;
  final String fullName;
  final String error;

  UserModel({
    this.token = '',
    this.userID = '',
    this.fullName = '',
    this.error = '',
  });

  UserModel copyWith({
    String? token,
    String? userID,
    String? error,
    String? fullName,
  }) {
    return UserModel(
      token: token ?? this.token,
      userID: userID ?? this.userID,
      fullName: fullName ?? this.fullName,
      error: error ?? this.error,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      userID: json['userID'] ?? '',
      fullName: json['fullName'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userID': userID,
      'fullName': fullName,
      'error': error,
    };
  }
}
