part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class UserNameChanged extends RegisterEvent {
  final String username;
  const UserNameChanged({required this.username});
  @override
  List<Object> get props => [username];
}

class EmailChanged extends RegisterEvent {
  final String email;
  const EmailChanged({required this.email});
  @override
  List<Object> get props => [email];
}

class PasswordChanged extends RegisterEvent {
  final String password;
  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  const ConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];
}

class SignupApi extends RegisterEvent {
  const SignupApi();
}

class LoginPage extends RegisterEvent {
  const LoginPage();
}
