part of 'user_profile_get_bloc.dart';

class UserProfileGetState extends Equatable {
  final ApiResponse<UserProfileResponse> userProfile;

  const UserProfileGetState({required this.userProfile});

  UserProfileGetState copyWith({
    ApiResponse<UserProfileResponse>? userProfile,
  }) {
    return UserProfileGetState(userProfile: userProfile ?? this.userProfile);
  }

  @override
  List<Object?> get props => [userProfile];
}
