part of 'post_comment_bloc.dart';

sealed class PostCommentEvent extends Equatable {
  const PostCommentEvent();
  @override
  List<Object> get props => [];
}

class PostCommentChanged extends PostCommentEvent {
  final String postCommit;
  const PostCommentChanged({required this.postCommit});
  @override
  List<Object> get props => [postCommit];
}

class PostCommentApi extends PostCommentEvent {
  const PostCommentApi();
}
