part of 'post_content_bloc.dart';

class PostContentState extends Equatable {
  final String userId;
  final String postContent;
  final io.File? mediaFile; // For mobile/desktop
  final Uint8List? mediaBytes; // For web
  final ApiResponse<String> postApiResponse;

  const PostContentState({
    this.userId = '',
    this.postContent = '',
    this.mediaFile,
    this.mediaBytes,
    this.postApiResponse = const ApiResponse.completed(''),
  });

  PostContentState copyWith({
    String? userId,
    String? postContent,
    io.File? mediaFile,
    Uint8List? mediaBytes,
    ApiResponse<String>? postApiResponse,
  }) {
    return PostContentState(
      userId: userId ?? this.userId,
      postContent: postContent ?? this.postContent,
      mediaFile: mediaFile ?? this.mediaFile,
      mediaBytes: mediaBytes ?? this.mediaBytes,
      postApiResponse: postApiResponse ?? this.postApiResponse,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    postContent,
    mediaFile,
    mediaBytes,
    postApiResponse,
  ];
}
