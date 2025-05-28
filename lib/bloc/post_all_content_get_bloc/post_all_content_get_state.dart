part of 'post_all_content_get_bloc.dart';

class PostAllContentGetState extends Equatable {
  const PostAllContentGetState({required this.postAllContentGetList});

  final ApiResponse<PostResponse> postAllContentGetList;

  PostAllContentGetState copyWith({
    ApiResponse<PostResponse>? postAllContentGetList,
  }) {
    return PostAllContentGetState(
      postAllContentGetList:
          postAllContentGetList ?? this.postAllContentGetList,
    );
  }

  @override
  List<Object?> get props => [postAllContentGetList];
}
