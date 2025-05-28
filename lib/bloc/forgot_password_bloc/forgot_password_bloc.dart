import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/forgot_password_api/forgot_password_api_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordApiRepository forgotPasswordApiRepository;

  ForgotPasswordBloc({required this.forgotPasswordApiRepository})
    : super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<ForgotPasswordApi>(_onFormSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _onFormSubmitted(
    ForgotPasswordApi event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    Map<String, String> data = {'email': state.email};
    emit(state.copyWith(forgotPasswordApi: const ApiResponse.loading()));

    await forgotPasswordApiRepository
        .forgotPasswordApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(
              state.copyWith(forgotPasswordApi: ApiResponse.error(value.error)),
            );
          } else {
            emit(
              state.copyWith(
                forgotPasswordApi: const ApiResponse.completed(
                  'Forgot Password',
                ),
              ),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              forgotPasswordApi: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
