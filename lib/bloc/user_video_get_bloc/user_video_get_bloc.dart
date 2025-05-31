import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:do_host/repository/user_video_get_api/user_video_get_api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../data/response/api_response.dart';
import '../../model/user_video_get/user_video_model.dart';

part 'user_video_get_event.dart';
part 'user_video_get_state.dart';

// user_video_get_bloc.dart
class UserVideoGetBloc extends Bloc<UserVideoGetEvent, UserVideoGetState> {
  final UserVideoGetApiRepository userVideoGetApiRepository;

  UserVideoGetBloc({required this.userVideoGetApiRepository})
    : super(UserVideoGetState(userVideoGetList: ApiResponse.loading())) {
    on<UserVideoGetFetch>(_fetchUserVideoGetListApi);
  }

  Future<void> _fetchUserVideoGetListApi(
    UserVideoGetFetch event,
    Emitter<UserVideoGetState> emit,
  ) async {
    try {
      final response = await userVideoGetApiRepository.fetchUserVideoList(
        event.userId,
      );
      emit(state.copyWith(userVideoGetList: ApiResponse.completed(response)));
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('Error fetching user videos: $error');
        print(stackTrace);
      }
      emit(
        state.copyWith(userVideoGetList: ApiResponse.error(error.toString())),
      );
    }
  }
}
