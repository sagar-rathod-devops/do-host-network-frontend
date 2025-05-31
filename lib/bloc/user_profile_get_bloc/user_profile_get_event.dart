part of 'user_profile_get_bloc.dart';

abstract class UserProfileGetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserProfileGetFetch extends UserProfileGetEvent {
  final String userId;

  UserProfileGetFetch(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserProfileDeleted extends UserProfileGetEvent {
  final String userId;

  UserProfileDeleted(this.userId);

  @override
  List<Object?> get props => [userId];
}
