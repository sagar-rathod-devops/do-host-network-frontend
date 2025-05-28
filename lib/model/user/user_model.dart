class UserModel {
  final String token;
  final String userID;
  final String error;

  UserModel({this.token = '', this.userID = '', this.error = ''});

  UserModel copyWith({String? token, String? userID, String? error}) {
    return UserModel(
      token: token ?? this.token,
      userID: userID ?? this.userID,
      error: error ?? this.error,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      userID: json['userID'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'userID': userID, 'error': error};
  }
}
