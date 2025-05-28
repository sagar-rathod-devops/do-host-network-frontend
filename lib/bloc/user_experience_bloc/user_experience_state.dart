part of 'user_experience_bloc.dart';

class UserExperienceState extends Equatable {
  const UserExperienceState({
    this.userId = '',
    this.jobTitle = '',
    this.companyName = '',
    this.location = '',
    this.jobDescription = '',
    this.achievements = '',
    this.startDate = '',
    this.endDate = '',
    this.profileImage = '',
    this.userExperienceApi = const ApiResponse.completed(''),
  });

  final String userId;
  final String jobTitle;
  final String companyName;
  final String location;
  final String jobDescription;
  final String achievements;
  final String startDate;
  final String endDate;
  final String profileImage;
  final ApiResponse<String> userExperienceApi;

  UserExperienceState copyWith({
    String? userId,
    String? jobTitle,
    String? companyName,
    String? location,
    String? jobDescription,
    String? achievements,
    String? startDate,
    String? endDate,
    String? profileImage,
    ApiResponse<String>? userExperienceApi,
  }) {
    return UserExperienceState(
      userId: userId ?? this.userId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      jobDescription: jobDescription ?? this.jobDescription,
      achievements: achievements ?? this.achievements,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      profileImage: profileImage ?? this.profileImage,
      userExperienceApi: userExperienceApi ?? this.userExperienceApi,
    );
  }

  @override
  List<Object> get props => [
    userId,
    jobTitle,
    companyName,
    jobDescription,
    achievements,
    startDate,
    endDate,
    location,
    profileImage,
    userExperienceApi,
  ];
}
