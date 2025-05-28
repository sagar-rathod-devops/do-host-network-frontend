import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/reset_password_api/reset_password_api_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordApiRepository resetPasswordApiRepository;

  ResetPasswordBloc({required this.resetPasswordApiRepository})
    : super(const ResetPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<OTPChanged>(_onOTPChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ResetPasswordApi>(_onFormSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<ResetPasswordState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onOTPChanged(OTPChanged event, Emitter<ResetPasswordState> emit) {
    emit(state.copyWith(otp: event.otp));
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  Future<void> _onFormSubmitted(
    ResetPasswordApi event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (state.password != state.confirmPassword) {
      emit(
        state.copyWith(
          resetPasswordApi: ApiResponse.error(
            "Password and Confirm Password do not match",
          ),
        ),
      );
      return;
    }

    Map<String, String> data = {
      'email': state.email,
      'otp': state.otp,
      'new_password': state.password,
    };
    emit(state.copyWith(resetPasswordApi: const ApiResponse.loading()));

    await resetPasswordApiRepository
        .resetPasswordApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(
              state.copyWith(resetPasswordApi: ApiResponse.error(value.error)),
            );
          } else {
            emit(
              state.copyWith(
                resetPasswordApi: const ApiResponse.completed('Reset Password'),
              ),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              resetPasswordApi: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
