part of 'user_video_get_bloc.dart';

class UserVideoGetState extends Equatable {
  final ApiResponse<List<UserVideoResponse>> userVideoGetList;

  const UserVideoGetState({required this.userVideoGetList});

  UserVideoGetState copyWith({
    ApiResponse<List<UserVideoResponse>>? userVideoGetList,
  }) {
    return UserVideoGetState(
      userVideoGetList: userVideoGetList ?? this.userVideoGetList,
    );
  }

  @override
  List<Object?> get props => [userVideoGetList];
}
