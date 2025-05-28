part of 'user_experience_bloc.dart';

sealed class UserExperienceEvent extends Equatable {
  const UserExperienceEvent();
  @override
  List<Object> get props => [];
}

class UserIdChanged extends UserExperienceEvent {
  final String userId;
  const UserIdChanged({required this.userId});
  @override
  List<Object> get props => [userId];
}

class JobTitleChanged extends UserExperienceEvent {
  final String jobTitle;
  const JobTitleChanged({required this.jobTitle});
  @override
  List<Object> get props => [jobTitle];
}

class CompanyNameChanged extends UserExperienceEvent {
  final String companyName;
  const CompanyNameChanged({required this.companyName});
  @override
  List<Object> get props => [companyName];
}

class LocationChanged extends UserExperienceEvent {
  final String location;
  const LocationChanged({required this.location});
  @override
  List<Object> get props => [location];
}

class JobDescriptionChanged extends UserExperienceEvent {
  final String jobDescription;
  const JobDescriptionChanged({required this.jobDescription});
  @override
  List<Object> get props => [jobDescription];
}

class AchievementsChanged extends UserExperienceEvent {
  final String achievements;
  const AchievementsChanged({required this.achievements});
  @override
  List<Object> get props => [achievements];
}

class EndDateChanged extends UserExperienceEvent {
  final String endDate;
  const EndDateChanged({required this.endDate});
  @override
  List<Object> get props => [endDate];
}

class StartDateChanged extends UserExperienceEvent {
  final String startDate;
  const StartDateChanged({required this.startDate});
  @override
  List<Object> get props => [startDate];
}

class ProfileImageChanged extends UserExperienceEvent {
  final String profileImage;
  const ProfileImageChanged({required this.profileImage});
  @override
  List<Object> get props => [profileImage];
}

class UserExperienceApi extends UserExperienceEvent {
  const UserExperienceApi();
}
