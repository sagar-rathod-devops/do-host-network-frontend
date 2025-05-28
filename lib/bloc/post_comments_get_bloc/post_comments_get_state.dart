part of 'post_comments_get_bloc.dart';

class PostCommentsGetState extends Equatable {
  const PostCommentsGetState({required this.postCommentsGetList});

  final ApiResponse<CommentListResponse> postCommentsGetList;

  PostCommentsGetState copyWith({
    ApiResponse<CommentListResponse>? postCommentsGetList,
  }) {
    return PostCommentsGetState(
      postCommentsGetList: postCommentsGetList ?? this.postCommentsGetList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [postCommentsGetList];
}
