import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/post_likes_get_api/post_likes_get_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/response/api_response.dart';
import '../../model/post_likes_get/like_model.dart';

part 'post_likes_get_event.dart';
part 'post_likes_get_state.dart';

class PostLikesGetBloc extends Bloc<PostLikesGetEvent, PostLikesGetState> {
  PostLikesGetApiRepository postLikesGetApiRepository;
  PostLikesGetBloc({required this.postLikesGetApiRepository})
    : super(PostLikesGetState(postLikesGetList: ApiResponse.loading())) {
    on<PostLikesGetFetch>(fetchPostLikesGetListApi);
  }

  Future<void> fetchPostLikesGetListApi(
    PostLikesGetFetch event,
    Emitter<PostLikesGetState> emit,
  ) async {
    await postLikesGetApiRepository
        .fetchPostLikesList()
        .then((response) {
          emit(
            state.copyWith(postLikesGetList: ApiResponse.completed(response)),
          );
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print(stackTrace);
            print(error);
          }

          emit(
            state.copyWith(
              postLikesGetList: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
