// post_all_content_get_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../data/response/api_response.dart';
import '../../model/post_all_content_get/post_model.dart';
import '../../repository/post_all_content_get_api/post_all_content_get_api_repository.dart';

part 'post_all_content_get_event.dart';
part 'post_all_content_get_state.dart';

class PostAllContentGetBloc
    extends Bloc<PostAllContentGetEvent, PostAllContentGetState> {
  final PostAllContentGetApiRepository postAllContentGetApiRepository;

  PostAllContentGetBloc({required this.postAllContentGetApiRepository})
    : super(
        PostAllContentGetState(postAllContentGetList: ApiResponse.loading()),
      ) {
    on<PostAllContentGetFetch>(_fetchPostAllContentGetList);
  }

  Future<void> _fetchPostAllContentGetList(
    PostAllContentGetFetch event,
    Emitter<PostAllContentGetState> emit,
  ) async {
    try {
      final response = await postAllContentGetApiRepository
          .fetchPostAllContentList();
      emit(
        state.copyWith(postAllContentGetList: ApiResponse.completed(response)),
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(stackTrace);
        print(error);
      }
      emit(
        state.copyWith(
          postAllContentGetList: ApiResponse.error(error.toString()),
        ),
      );
    }
  }
}
