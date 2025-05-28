part of 'user_followers_bloc.dart';

class UserFollowersState extends Equatable {
  const UserFollowersState({required this.userFollowersList});

  final ApiResponse<FollowerResponse> userFollowersList;

  UserFollowersState copyWith({
    ApiResponse<FollowerResponse>? userFollowersList,
  }) {
    return UserFollowersState(
      userFollowersList: userFollowersList ?? this.userFollowersList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userFollowersList];
}
