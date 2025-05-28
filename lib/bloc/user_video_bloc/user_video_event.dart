part of 'user_video_bloc.dart';

sealed class UserVideoEvent extends Equatable {
  const UserVideoEvent();

  @override
  List<Object> get props => [];
}

class UserIdChanged extends UserVideoEvent {
  final String userId;
  const UserIdChanged({required this.userId});

  @override
  List<Object> get props => [userId];
}

class VideoFileChanged extends UserVideoEvent {
  final File videoFile;
  const VideoFileChanged({required this.videoFile});

  @override
  List<Object> get props => [videoFile];
}

class SubmitUserVideo extends UserVideoEvent {
  const SubmitUserVideo();

  @override
  List<Object> get props => [];
}
