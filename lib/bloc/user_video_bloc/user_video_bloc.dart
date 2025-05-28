import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/response/api_response.dart';
import '../../repository/user_video_api/user_video_repository.dart';

part 'user_video_event.dart';
part 'user_video_state.dart';

class UserVideoBloc extends Bloc<UserVideoEvent, UserVideoState> {
  final UserVideoApiRepository userVideoApiRepository;

  UserVideoBloc({required this.userVideoApiRepository})
    : super(const UserVideoState()) {
    on<UserIdChanged>(_onUserIdChanged);
    on<VideoFileChanged>(_onVideoFileChanged);
    on<SubmitUserVideo>(_onSubmitUserVideo);
  }

  void _onUserIdChanged(UserIdChanged event, Emitter<UserVideoState> emit) {
    emit(state.copyWith(userId: event.userId));
  }

  void _onVideoFileChanged(
    VideoFileChanged event,
    Emitter<UserVideoState> emit,
  ) {
    emit(state.copyWith(videoFile: event.videoFile));
  }

  Future<void> _onSubmitUserVideo(
    SubmitUserVideo event,
    Emitter<UserVideoState> emit,
  ) async {
    if (state.videoFile == null) {
      emit(
        state.copyWith(userVideoApi: ApiResponse.error("No video selected.")),
      );
      return;
    }

    emit(state.copyWith(userVideoApi: const ApiResponse.loading()));

    try {
      final formData = {
        'user_id': state.userId,
        'video_file': state.videoFile, // Adjust key if needed for backend
      };

      final result = await userVideoApiRepository.userVideoApi(formData);

      if (result.error.isNotEmpty) {
        emit(state.copyWith(userVideoApi: ApiResponse.error(result.error)));
      } else {
        emit(
          state.copyWith(
            userVideoApi: const ApiResponse.completed(
              "Video uploaded successfully",
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          userVideoApi: ApiResponse.error("Error: ${e.toString()}"),
        ),
      );
    }
  }
}
