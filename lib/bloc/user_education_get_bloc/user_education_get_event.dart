part of 'user_education_get_bloc.dart';

abstract class UserEducationGetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserEducationGetFetch extends UserEducationGetEvent {
  final String userId;

  UserEducationGetFetch(this.userId);

  @override
  List<Object?> get props => [userId];
}
