part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.signupApi = const ApiResponse.completed(''),
  });

  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final ApiResponse<String> signupApi;

  RegisterState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    ApiResponse<String>? signupApi,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      signupApi: signupApi ?? this.signupApi,
    );
  }

  @override
  List<Object> get props => [
    username,
    email,
    password,
    confirmPassword,
    signupApi,
  ];
}
