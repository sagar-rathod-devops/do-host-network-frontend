part of 'user_followings_bloc.dart';

class UserFollowingsState extends Equatable {
  const UserFollowingsState({required this.userFollowingsList});

  final ApiResponse<FollowingResponse> userFollowingsList;

  UserFollowingsState copyWith({
    ApiResponse<FollowingResponse>? userFollowingsList,
  }) {
    return UserFollowingsState(
      userFollowingsList: userFollowingsList ?? this.userFollowingsList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userFollowingsList];
}
