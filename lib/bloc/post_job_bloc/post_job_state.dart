part of 'post_job_bloc.dart';

class PostJobState extends Equatable {
  const PostJobState({
    this.userId = '',
    this.jobTitle = '',
    this.companyName = '',
    this.jobDescription = '',
    this.jobApplyUrl = '',
    this.location = '',
    this.lastDateToApply = '',
    this.postJobApi = const ApiResponse.completed(''),
  });

  final String userId;
  final String jobTitle;
  final String companyName;
  final String jobDescription;
  final String jobApplyUrl;
  final String location;
  final String lastDateToApply;
  final ApiResponse<String> postJobApi;

  PostJobState copyWith({
    String? userId,
    String? jobTitle,
    String? companyName,
    String? jobDescription,
    String? jobApplyUrl,
    String? location,
    String? lastDateToApply,
    ApiResponse<String>? postJobApi,
  }) {
    return PostJobState(
      userId: userId ?? this.userId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      jobDescription: jobDescription ?? this.jobDescription,
      jobApplyUrl: jobApplyUrl ?? this.jobApplyUrl,
      location: location ?? this.location,
      lastDateToApply: lastDateToApply ?? this.lastDateToApply,
      postJobApi: postJobApi ?? this.postJobApi,
    );
  }

  @override
  List<Object> get props => [
    userId,
    jobTitle,
    companyName,
    jobDescription,
    jobApplyUrl,
    location,
    lastDateToApply,
    postJobApi,
  ];
}
