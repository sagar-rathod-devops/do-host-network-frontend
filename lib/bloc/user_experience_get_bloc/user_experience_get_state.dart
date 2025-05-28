part of 'user_experience_get_bloc.dart';

class UserExperienceGetState extends Equatable {
  const UserExperienceGetState({required this.userExperienceGetList});

  final ApiResponse<UserExperienceListResponse> userExperienceGetList;

  UserExperienceGetState copyWith({
    ApiResponse<UserExperienceListResponse>? userExperienceGetList,
  }) {
    return UserExperienceGetState(
      userExperienceGetList:
          userExperienceGetList ?? this.userExperienceGetList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userExperienceGetList];
}
