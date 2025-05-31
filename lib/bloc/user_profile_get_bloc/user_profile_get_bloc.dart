import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:do_host/data/response/status.dart';
import 'package:do_host/repository/user_profile_get_api/user_profile_get_api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../data/response/api_response.dart';
import '../../model/user_profile_get/user_profile_get_model.dart';

part 'user_profile_get_event.dart';
part 'user_profile_get_state.dart';

class UserProfileGetBloc
    extends Bloc<UserProfileGetEvent, UserProfileGetState> {
  final UserProfileGetApiRepository userProfileGetApiRepository;

  UserProfileGetBloc({required this.userProfileGetApiRepository})
    : super(UserProfileGetState(userProfile: ApiResponse.loading())) {
    on<UserProfileGetFetch>(_fetchUserProfile);
    on<UserProfileDeleted>(_deleteUserProfileFromState);
  }

  Future<void> _fetchUserProfile(
    UserProfileGetFetch event,
    Emitter<UserProfileGetState> emit,
  ) async {
    emit(state.copyWith(userProfile: ApiResponse.loading()));
    try {
      final profile = await userProfileGetApiRepository.fetchUserProfile(
        event.userId,
      );
      emit(state.copyWith(userProfile: ApiResponse.completed(profile)));
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      emit(state.copyWith(userProfile: ApiResponse.error(e.toString())));
    }
  }

  //   void _deleteUserProfileFromState(
  //     UserProfileDeleted event,
  //     Emitter<UserProfileGetState> emit,
  //   ) {
  //     final current = state.userProfile;
  //     if (current.status == Status.COMPLETED &&
  //         current.data?.userId == event.userId) {
  //       emit(state.copyWith(userProfile: ApiResponse.completed(null)));
  //     }
  //   }
  // }

  void _deleteUserProfileFromState(
    UserProfileDeleted event,
    Emitter<UserProfileGetState> emit,
  ) async {
    final current = state.userProfile;
    if (current.status == Status.COMPLETED &&
        current.data?.userId == event.userId) {
      final profile = await userProfileGetApiRepository.fetchUserProfile(
        event.userId,
      );
      emit(state.copyWith(userProfile: ApiResponse.completed(profile)));
    }
  }
}
