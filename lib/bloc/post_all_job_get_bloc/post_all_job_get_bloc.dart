import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_host/repository/post_all_job_get_api/post_all_job_get_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/response/api_response.dart';
import '../../model/post_all_job_get/job_post_model.dart';

part 'post_all_job_get_event.dart';
part 'post_all_job_get_state.dart';

class PostAllJobGetBloc extends Bloc<PostAllJobGetEvent, PostAllJobGetState> {
  PostAllJobGetApiRepository postAllJobGetApiRepository;
  PostAllJobGetBloc({required this.postAllJobGetApiRepository})
    : super(PostAllJobGetState(postAllJobGetList: ApiResponse.loading())) {
    on<PostAllJobGetFetch>(fetchPostAllJobGetListApi);
  }

  Future<void> fetchPostAllJobGetListApi(
    PostAllJobGetFetch event,
    Emitter<PostAllJobGetState> emit,
  ) async {
    await postAllJobGetApiRepository
        .fetchPostAllJobList()
        .then((response) {
          emit(
            state.copyWith(postAllJobGetList: ApiResponse.completed(response)),
          );
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print(stackTrace);
            print(error);
          }

          emit(
            state.copyWith(
              postAllJobGetList: ApiResponse.error(error.toString()),
            ),
          );
        });
  }
}
