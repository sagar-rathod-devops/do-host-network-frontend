import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_unfollow_event.dart';
part 'user_unfollow_state.dart';

class UserUnfollowBloc extends Bloc<UserUnfollowEvent, UserUnfollowState> {
  UserUnfollowBloc() : super(UserUnfollowInitial());

  @override
  Stream<UserUnfollowState> mapEventToState(UserUnfollowEvent event) async* {
    // TODO: implement mapEventToState
  }
}
