part of 'post_likes_get_bloc.dart';

class PostLikesGetState extends Equatable {
  const PostLikesGetState({required this.postLikesGetList});

  final ApiResponse<LikeResponse> postLikesGetList;

  PostLikesGetState copyWith({ApiResponse<LikeResponse>? postLikesGetList}) {
    return PostLikesGetState(
      postLikesGetList: postLikesGetList ?? this.postLikesGetList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [postLikesGetList];
}
