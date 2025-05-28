import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/user_followings_api/user_followings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/response/api_response.dart';
import '../../model/user_followings/following_model.dart';

part 'user_followings_event.dart';
part 'user_followings_state.dart';

class UserFollowingsBloc
    extends Bloc<UserFollowingsEvent, UserFollowingsState> {
  UserFollowingsApiRepository userFollowingsApiRepository;
  UserFollowingsBloc({required this.userFollowingsApiRepository})
    : super(UserFollowingsState(userFollowingsList: ApiResponse.loading())) {
    on<UserFollowingsFetch>(fetchUserFollowingsListApi);
  }

  Future<void> fetchUserFollowingsListApi(
    UserFollowingsFetch event,
    Emitter<UserFollowingsState> emit,
  ) async {
    await userFollowingsApiRepository
        .fetchUserFollowingsList()
        .then((response) {
          emit(
            state.copyWith(userFollowingsList: ApiResponse.completed(response)),
          );
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print(stackTrace);
            print(error);
          }

          emit(
            state.copyWith(
              userFollowingsList: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
