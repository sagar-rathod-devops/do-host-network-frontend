part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.forgotPasswordApi = const ApiResponse.completed(''),
  });

  final String email;
  final ApiResponse<String> forgotPasswordApi;

  ForgotPasswordState copyWith({
    String? email,
    ApiResponse<String>? forgotPasswordApi,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      forgotPasswordApi: forgotPasswordApi ?? this.forgotPasswordApi,
    );
  }

  @override
  List<Object> get props => [email, forgotPasswordApi];
}
