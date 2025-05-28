part of 'user_profile_get_bloc.dart';

class UserProfileGetState extends Equatable {
  const UserProfileGetState({required this.userProfileGetList});

  final ApiResponse<UserProfileResponse> userProfileGetList;

  UserProfileGetState copyWith({
    ApiResponse<UserProfileResponse>? userProfileGetList,
  }) {
    return UserProfileGetState(
      userProfileGetList: userProfileGetList ?? this.userProfileGetList,
    );
  }

  @override
  List<Object?> get props => [userProfileGetList];
}
