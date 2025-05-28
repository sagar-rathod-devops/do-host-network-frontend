part of 'post_content_bloc.dart';

sealed class PostContentEvent extends Equatable {
  const PostContentEvent();

  @override
  List<Object?> get props => [];
}

class UserIdChanged extends PostContentEvent {
  final String userId;
  const UserIdChanged({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class PostContentChanged extends PostContentEvent {
  final String postContent;
  const PostContentChanged({required this.postContent});

  @override
  List<Object?> get props => [postContent];
}

class MediaUrlChanged extends PostContentEvent {
  final File mediaFile;
  const MediaUrlChanged({required this.mediaFile});

  @override
  List<Object?> get props => [mediaFile];
}

class SubmitPostApi extends PostContentEvent {
  const SubmitPostApi();

  @override
  List<Object?> get props => [];
}
