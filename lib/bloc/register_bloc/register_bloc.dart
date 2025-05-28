import 'dart:async';
import 'package:do_host/data/response/api_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/register_api/register_api_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterApiRepository registerApiRepository;

  RegisterBloc({required this.registerApiRepository})
    : super(const RegisterState()) {
    on<UserNameChanged>(_onUsernameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupApi>(_onFormSubmitted);
  }

  void _onUsernameChanged(UserNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onEmailChanged(EmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  Future<void> _onFormSubmitted(
    SignupApi event,
    Emitter<RegisterState> emit,
  ) async {
    // Check if password and confirmPassword match
    if (state.password != state.confirmPassword) {
      emit(
        state.copyWith(
          signupApi: ApiResponse.error(
            "Password and Confirm Password do not match",
          ),
        ),
      );
      return;
    }

    Map<String, String> data = {
      'username': state.username,
      'email': state.email,
      'password': state.password,
    };

    emit(state.copyWith(signupApi: const ApiResponse.loading()));

    await registerApiRepository
        .signupApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(state.copyWith(signupApi: ApiResponse.error(value.error)));
          } else {
            emit(
              state.copyWith(signupApi: const ApiResponse.completed('Sign-Up')),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(state.copyWith(signupApi: ApiResponse.error(error.toString())));
        });
  }
}
