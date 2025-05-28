import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/user_experience_get_api/user_experience_get_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/response/api_response.dart';
import '../../model/user_experience_get/user_experience_get_model.dart';

part 'user_experience_get_event.dart';
part 'user_experience_get_state.dart';

class UserExperienceGetBloc
    extends Bloc<UserExperienceGetEvent, UserExperienceGetState> {
  UserExperienceGetApiRepository userExperienceGetApiRepository;
  UserExperienceGetBloc({required this.userExperienceGetApiRepository})
    : super(
        UserExperienceGetState(userExperienceGetList: ApiResponse.loading()),
      ) {
    on<UserExperienceGetFetch>(fetchUserExperienceGetListApi);
  }

  Future<void> fetchUserExperienceGetListApi(
    UserExperienceGetFetch event,
    Emitter<UserExperienceGetState> emit,
  ) async {
    await userExperienceGetApiRepository
        .fetchUserExperienceList()
        .then((response) {
          emit(
            state.copyWith(
              userExperienceGetList: ApiResponse.completed(response),
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
              userExperienceGetList: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
