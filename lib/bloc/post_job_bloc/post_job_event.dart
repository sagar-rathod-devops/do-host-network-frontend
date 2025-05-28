part of 'post_job_bloc.dart';

sealed class PostJobEvent extends Equatable {
  const PostJobEvent();
  @override
  List<Object> get props => [];
}

class UserIdChanged extends PostJobEvent {
  final String userId;
  const UserIdChanged({required this.userId});
  @override
  List<Object> get props => [userId];
}

class JobTitleChanged extends PostJobEvent {
  final String jobTitle;
  const JobTitleChanged({required this.jobTitle});
  @override
  List<Object> get props => [jobTitle];
}

class CompanyNameChanged extends PostJobEvent {
  final String companyName;
  const CompanyNameChanged({required this.companyName});
  @override
  List<Object> get props => [companyName];
}

class JobDescriptionChanged extends PostJobEvent {
  final String jobDescription;
  const JobDescriptionChanged({required this.jobDescription});
  @override
  List<Object> get props => [jobDescription];
}

class JobApplyUrlChanged extends PostJobEvent {
  final String jobApplyUrl;
  const JobApplyUrlChanged({required this.jobApplyUrl});
  @override
  List<Object> get props => [jobApplyUrl];
}

class LocationChanged extends PostJobEvent {
  final String location;
  const LocationChanged({required this.location});
  @override
  List<Object> get props => [location];
}

class LastDateToApplyChanged extends PostJobEvent {
  final String lastDateToApply;
  const LastDateToApplyChanged({required this.lastDateToApply});
  @override
  List<Object> get props => [lastDateToApply];
}

class PostJobApi extends PostJobEvent {
  const PostJobApi();
}
