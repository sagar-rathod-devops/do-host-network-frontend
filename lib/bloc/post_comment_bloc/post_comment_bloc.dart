import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/post_comment_api/post_comment_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/response/api_response.dart';

part 'post_comment_event.dart';
part 'post_comment_state.dart';

class PostCommentBloc extends Bloc<PostCommentEvent, PostCommentState> {
  PostCommentApiRepository postCommentApiRepository;

  PostCommentBloc({required this.postCommentApiRepository})
    : super(const PostCommentState()) {
    on<PostCommentChanged>(_onPostCommentChanged);
    on<PostCommentApi>(_onFormSubmitted);
  }

  void _onPostCommentChanged(
    PostCommentChanged event,
    Emitter<PostCommentState> emit,
  ) {
    emit(state.copyWith(comment: event.postCommit));
  }

  Future<void> _onFormSubmitted(
    PostCommentApi event,
    Emitter<PostCommentState> emit,
  ) async {
    Map<String, String> data = {'comment': state.comment};

    emit(state.copyWith(postCommentApi: const ApiResponse.loading()));

    await postCommentApiRepository
        .postCommentApi(data)
        .then((value) async {
          if (value.error.isNotEmpty) {
            emit(
              state.copyWith(postCommentApi: ApiResponse.error(value.error)),
            );
          } else {
            emit(
              state.copyWith(
                postCommentApi: const ApiResponse.completed('Sign-Up'),
              ),
            );
          }
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(postCommentApi: ApiResponse.error(error.toString())),
          );
        });
  }
}
