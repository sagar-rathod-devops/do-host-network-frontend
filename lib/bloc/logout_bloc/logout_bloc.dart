import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/logout_api/logout_api_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutApiRepository logoutApiRepository;

  LogoutBloc({required this.logoutApiRepository}) : super(const LogoutState()) {
    on<LogoutApi>(_onFormSubmitted);
  }

  Future<void> _onFormSubmitted(
    LogoutApi event,
    Emitter<LogoutState> emit,
  ) async {
    emit(state.copyWith(logoutApi: const ApiResponse.loading()));

    await logoutApiRepository
        .logoutApi()
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(state.copyWith(logoutApi: ApiResponse.error(value.error)));
          } else {
            emit(
              state.copyWith(logoutApi: const ApiResponse.completed('Logout')),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(state.copyWith(logoutApi: ApiResponse.error(error.toString())));
        });
  }
}
