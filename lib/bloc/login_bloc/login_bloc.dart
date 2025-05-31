import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/data/response/api_response.dart';
import 'package:equatable/equatable.dart';

import '../../repository/auth_api/auth_api_repository.dart';
import '../../services/session_manager/session_controller.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  AuthApiRepository authApiRepository;

  LoginBloc({required this.authApiRepository}) : super(const LoginStates()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginApi>(_onFormSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginStates> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginStates> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onFormSubmitted(
    LoginApi event,
    Emitter<LoginStates> emit,
  ) async {
    Map<String, String> data = {
      'identifier': state.email,
      'password': state.password,
    };

    emit(state.copyWith(loginApi: const ApiResponse.loading()));

    try {
      final response = await authApiRepository.loginApi(data);

      if (response.error.isNotEmpty) {
        emit(state.copyWith(loginApi: ApiResponse.error(response.error)));
      } else {
        // Convert UserModel to Map<String, dynamic> before saving
        await SessionController().saveUserInPreference(response.toJson());

        // Optional: Fetch user from preference to update local state
        await SessionController().getUserFromPreference();

        emit(state.copyWith(loginApi: const ApiResponse.completed('LOGIN')));
      }
    } catch (error) {
      emit(state.copyWith(loginApi: ApiResponse.error(error.toString())));
    }
  }
}
