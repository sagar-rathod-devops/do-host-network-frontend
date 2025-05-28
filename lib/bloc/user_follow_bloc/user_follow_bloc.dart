import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_follow_event.dart';
part 'user_follow_state.dart';

class UserFollowBloc extends Bloc<UserFollowEvent, UserFollowState> {
  UserFollowBloc() : super(UserFollowInitial());

  @override
  Stream<UserFollowState> mapEventToState(UserFollowEvent event) async* {
    // TODO: implement mapEventToState
  }
}
