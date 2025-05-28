part of 'user_video_get_bloc.dart';

class UserVideoGetState extends Equatable {
  final ApiResponse<UserVideoResponse> userVideoGetList;

  const UserVideoGetState({required this.userVideoGetList});

  UserVideoGetState copyWith({
    ApiResponse<UserVideoResponse>? userVideoGetList,
  }) {
    return UserVideoGetState(
      userVideoGetList: userVideoGetList ?? this.userVideoGetList,
    );
  }

  @override
  List<Object?> get props => [userVideoGetList];
}
