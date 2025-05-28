part of 'all_user_profile_get_bloc_bloc.dart';

class AllUserProfileGetBlocState extends Equatable {
  const AllUserProfileGetBlocState({required this.allUserProfileGetList});

  final ApiResponse<AllUserProfileResponse> allUserProfileGetList;

  AllUserProfileGetBlocState copyWith({
    ApiResponse<AllUserProfileResponse>? allUserProfileGetList,
  }) {
    return AllUserProfileGetBlocState(
      allUserProfileGetList:
          allUserProfileGetList ?? this.allUserProfileGetList,
    );
  }

  @override
  List<Object?> get props => [allUserProfileGetList];
}
