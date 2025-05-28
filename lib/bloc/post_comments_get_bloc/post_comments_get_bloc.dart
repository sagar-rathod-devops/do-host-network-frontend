import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/post_comments_get_api/post_comments_get_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/response/api_response.dart';
import '../../model/post_comments_get/comment_model.dart';

part 'post_comments_get_event.dart';
part 'post_comments_get_state.dart';

class PostCommentsGetBloc
    extends Bloc<PostCommentsGetEvent, PostCommentsGetState> {
  PostCommentsGetApiRepository postCommentsGetApiRepository;
  PostCommentsGetBloc({required this.postCommentsGetApiRepository})
    : super(PostCommentsGetState(postCommentsGetList: ApiResponse.loading())) {
    on<PostCommentsGetFetch>(fetchPostCommentsGetListApi);
  }

  Future<void> fetchPostCommentsGetListApi(
    PostCommentsGetFetch event,
    Emitter<PostCommentsGetState> emit,
  ) async {
    await postCommentsGetApiRepository
        .fetchPostCommentsList()
        .then((response) {
          emit(
            state.copyWith(
              postCommentsGetList: ApiResponse.completed(response),
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
              postCommentsGetList: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
