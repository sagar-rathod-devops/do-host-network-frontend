part of 'user_video_bloc.dart';

class UserVideoState extends Equatable {
  const UserVideoState({
    this.userId = '',
    this.videoFile,
    this.userVideoApi = const ApiResponse.completed(''),
  });

  final String userId;
  final File? videoFile;
  final ApiResponse<String> userVideoApi;

  UserVideoState copyWith({
    String? userId,
    File? videoFile,
    ApiResponse<String>? userVideoApi,
  }) {
    return UserVideoState(
      userId: userId ?? this.userId,
      videoFile: videoFile ?? this.videoFile,
      userVideoApi: userVideoApi ?? this.userVideoApi,
    );
  }

  @override
  List<Object?> get props => [userId, videoFile, userVideoApi];
}
