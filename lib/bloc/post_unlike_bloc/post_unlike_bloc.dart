import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_unlike_event.dart';
part 'post_unlike_state.dart';

class PostUnlikeBloc extends Bloc<PostUnlikeEvent, PostUnlikeState> {
  PostUnlikeBloc() : super(PostUnlikeInitial());

  @override
  Stream<PostUnlikeState> mapEventToState(PostUnlikeEvent event) async* {
    // TODO: implement mapEventToState
  }
}
