part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
  @override
  List<Object> get props => [];
}

class EmailChanged extends ResetPasswordEvent {
  final String email;
  const EmailChanged({required this.email});
  @override
  List<Object> get props => [email];
}

class OTPChanged extends ResetPasswordEvent {
  final String otp;
  const OTPChanged({required this.otp});
  @override
  List<Object> get props => [otp];
}

class PasswordChanged extends ResetPasswordEvent {
  final String password;
  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends ResetPasswordEvent {
  final String confirmPassword;
  const ConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];
}

class ResetPasswordApi extends ResetPasswordEvent {
  const ResetPasswordApi();
}
