import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/user_education_get_api/user_education_get_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/response/api_response.dart';
import '../../model/user_education_get/user_education_get_model.dart';

part 'user_education_get_event.dart';
part 'user_education_get_state.dart';

class UserEducationGetBloc
    extends Bloc<UserEducationGetEvent, UserEducationGetState> {
  UserEducationGetApiRepository userEducationGetApiRepository;
  UserEducationGetBloc({required this.userEducationGetApiRepository})
    : super(
        UserEducationGetState(userEducationGetList: ApiResponse.loading()),
      ) {
    on<UserEducationGetFetch>(fetchUserEducationGetListApi);
  }

  Future<void> fetchUserEducationGetListApi(
    UserEducationGetFetch event,
    Emitter<UserEducationGetState> emit,
  ) async {
    await userEducationGetApiRepository
        .fetchUserEducationList(event.userId)
        .then((response) {
          emit(
            state.copyWith(
              userEducationGetList: ApiResponse.completed(response),
            ),
          );
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print(stackTrace);
            print(error);
          }
          emit(
            state.copyWith(
              userEducationGetList: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
