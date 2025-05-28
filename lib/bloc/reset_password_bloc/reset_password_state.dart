part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.email = '',
    this.otp = '',
    this.password = '',
    this.confirmPassword = '',
    this.resetPasswordApi = const ApiResponse.completed(''),
  });

  final String email;
  final String otp;
  final String password;
  final String confirmPassword;
  final ApiResponse<String> resetPasswordApi;

  ResetPasswordState copyWith({
    String? email,
    String? otp,
    String? password,
    String? confirmPassword,
    ApiResponse<String>? resetPasswordApi,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      resetPasswordApi: resetPasswordApi ?? this.resetPasswordApi,
    );
  }

  @override
  List<Object> get props => [
    email,
    otp,
    password,
    confirmPassword,
    resetPasswordApi,
  ];
}
