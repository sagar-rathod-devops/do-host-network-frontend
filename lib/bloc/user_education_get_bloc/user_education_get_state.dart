part of 'user_education_get_bloc.dart';

class UserEducationGetState extends Equatable {
  const UserEducationGetState({required this.userEducationGetList});

  final ApiResponse<UserEducationListResponse> userEducationGetList;

  UserEducationGetState copyWith({
    ApiResponse<UserEducationListResponse>? userEducationGetList,
  }) {
    return UserEducationGetState(
      userEducationGetList: userEducationGetList ?? this.userEducationGetList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userEducationGetList];
}
