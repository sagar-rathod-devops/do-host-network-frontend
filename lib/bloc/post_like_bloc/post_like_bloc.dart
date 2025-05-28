import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_like_event.dart';
part 'post_like_state.dart';

class PostLikeBloc extends Bloc<PostLikeEvent, PostLikeState> {
  PostLikeBloc() : super(PostLikeInitial());

  @override
  Stream<PostLikeState> mapEventToState(PostLikeEvent event) async* {
    // TODO: implement mapEventToState
  }
}
