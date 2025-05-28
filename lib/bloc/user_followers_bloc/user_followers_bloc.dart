import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/user_followers_api/user_followers_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/response/api_response.dart';
import '../../model/user_followers/follower_model.dart';

part 'user_followers_event.dart';
part 'user_followers_state.dart';

class UserFollowersBloc extends Bloc<UserFollowersEvent, UserFollowersState> {
  UserFollowersApiRepository userFollowersApiRepository;
  UserFollowersBloc({required this.userFollowersApiRepository})
    : super(UserFollowersState(userFollowersList: ApiResponse.loading())) {
    on<UserFollowersFetch>(fetchUserFollowersListApi);
  }

  Future<void> fetchUserFollowersListApi(
    UserFollowersFetch event,
    Emitter<UserFollowersState> emit,
  ) async {
    await userFollowersApiRepository
        .fetchUserFollowersList()
        .then((response) {
          emit(
            state.copyWith(userFollowersList: ApiResponse.completed(response)),
          );
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print(stackTrace);
            print(error);
          }

          emit(
            state.copyWith(
              userFollowersList: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
