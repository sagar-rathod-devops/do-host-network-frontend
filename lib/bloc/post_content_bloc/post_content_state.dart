part of 'post_content_bloc.dart';

class PostContentState extends Equatable {
  final String userId;
  final String postContent;
  final File? mediaFile;
  final ApiResponse<String> postApiResponse;

  const PostContentState({
    this.userId = '',
    this.postContent = '',
    this.mediaFile,
    this.postApiResponse = const ApiResponse.completed(''),
  });

  PostContentState copyWith({
    String? userId,
    String? postContent,
    File? mediaFile,
    ApiResponse<String>? postApiResponse,
  }) {
    return PostContentState(
      userId: userId ?? this.userId,
      postContent: postContent ?? this.postContent,
      mediaFile: mediaFile ?? this.mediaFile,
      postApiResponse: postApiResponse ?? this.postApiResponse,
    );
  }

  @override
  List<Object?> get props => [userId, postContent, mediaFile, postApiResponse];
}
