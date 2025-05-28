import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:do_host/data/response/status.dart';
import 'package:do_host/repository/user_profile_get_api/user_profile_get_repository.dart';
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
    : super(UserProfileGetState(userProfileGetList: ApiResponse.loading())) {
    on<UserProfileGetFetch>(_fetchUserProfile);
    on<UserProfileDeleted>(_deleteUserProfileFromState);
  }

  Future<void> _fetchUserProfile(
    UserProfileGetFetch event,
    Emitter<UserProfileGetState> emit,
  ) async {
    emit(state.copyWith(userProfileGetList: ApiResponse.loading()));
    try {
      final profile = await userProfileGetApiRepository.fetchUserProfileList();
      emit(state.copyWith(userProfileGetList: ApiResponse.completed(profile)));
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      emit(state.copyWith(userProfileGetList: ApiResponse.error(e.toString())));
    }
  }

  void _deleteUserProfileFromState(
    UserProfileDeleted event,
    Emitter<UserProfileGetState> emit,
  ) async {
    final current = state.userProfileGetList;
    if (current.status == Status.COMPLETED &&
        current.data?.userId == event.userId) {
      final profile = await userProfileGetApiRepository.fetchUserProfileList();
      emit(state.copyWith(userProfileGetList: ApiResponse.completed(profile)));
    }
  }

  // void _deleteUserProfileFromState(
  //   UserProfileDeleted event,
  //   Emitter<UserProfileGetState> emit,
  // ) {
  //   final current = state.userProfileGetList;
  //   if (current.status == Status.COMPLETED &&
  //       current.data?.userId == event.userId) {
  //     emit(
  //       state.copyWith(
  //         userProfileGetList: ApiResponse.completed(UserProfileResponse()),
  //       ),
  //     );
  //   }
  // }
}
