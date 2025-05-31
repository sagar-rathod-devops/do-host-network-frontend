part of 'user_experience_get_bloc.dart';

abstract class UserExperienceGetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserExperienceGetFetch extends UserExperienceGetEvent {
  final String userId;

  UserExperienceGetFetch(this.userId);

  @override
  List<Object?> get props => [userId];
}
