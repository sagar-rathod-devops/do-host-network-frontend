part of 'post_comment_bloc.dart';

class PostCommentState extends Equatable {
  const PostCommentState({
    this.comment = '',
    this.postCommentApi = const ApiResponse.completed(''),
  });

  final String comment;
  final ApiResponse<String> postCommentApi;

  PostCommentState copyWith({
    String? comment,
    ApiResponse<String>? postCommentApi,
  }) {
    return PostCommentState(
      comment: comment ?? this.comment,
      postCommentApi: postCommentApi ?? this.postCommentApi,
    );
  }

  @override
  List<Object> get props => [comment, postCommentApi];
}
