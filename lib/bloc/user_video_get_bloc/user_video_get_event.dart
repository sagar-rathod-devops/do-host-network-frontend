// user_video_get_event.dart
part of 'user_video_get_bloc.dart';

abstract class UserVideoGetEvent {}

class UserVideoGetFetch extends UserVideoGetEvent {
  final String userId;

  UserVideoGetFetch({required this.userId});
}
