import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io' as io;
import '../../data/response/api_response.dart';
import '../../repository/post_content_api/post_content_api_repository.dart';

part 'post_content_event.dart';
part 'post_content_state.dart';

class PostContentBloc extends Bloc<PostContentEvent, PostContentState> {
  final PostContentApiRepository postApiRepository;

  PostContentBloc({required this.postApiRepository})
    : super(const PostContentState()) {
    on<UserIdChanged>(_onUserIdChanged);
    on<PostContentChanged>(_onPostContentChanged);
    on<MediaUrlChanged>(_onMediaUrlChanged);
    on<SubmitPostApi>(_onSubmitPostApi);
  }

  void _onUserIdChanged(UserIdChanged event, Emitter<PostContentState> emit) {
    emit(state.copyWith(userId: event.userId));
  }

  void _onPostContentChanged(
    PostContentChanged event,
    Emitter<PostContentState> emit,
  ) {
    emit(state.copyWith(postContent: event.postContent));
  }

  void _onMediaUrlChanged(
    MediaUrlChanged event,
    Emitter<PostContentState> emit,
  ) {
    emit(
      state.copyWith(mediaFile: event.mediaFile, mediaBytes: event.mediaBytes),
    );
  }

  Future<void> _onSubmitPostApi(
    SubmitPostApi event,
    Emitter<PostContentState> emit,
  ) async {
    if (state.mediaFile == null && state.mediaBytes == null) {
      emit(
        state.copyWith(
          postApiResponse: ApiResponse.error("No image selected."),
        ),
      );
      return;
    }

    emit(state.copyWith(postApiResponse: ApiResponse.loading()));

    try {
      final Map<String, dynamic> postData = {
        'user_id': state.userId,
        'post_content': state.postContent,
      };

      if (state.mediaFile != null) {
        postData['media_file'] = state.mediaFile; // For mobile/desktop
      } else if (state.mediaBytes != null) {
        postData['media_bytes'] = state.mediaBytes; // For web
      }

      final result = await postApiRepository.postContentApi(postData);

      emit(
        state.copyWith(
          postApiResponse: ApiResponse.completed("Post uploaded successfully"),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          postApiResponse: ApiResponse.error("Error: ${e.toString()}"),
        ),
      );
    }
  }
}
