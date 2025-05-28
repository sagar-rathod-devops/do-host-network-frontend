part of 'post_all_job_get_bloc.dart';

class PostAllJobGetState extends Equatable {
  const PostAllJobGetState({required this.postAllJobGetList});

  final ApiResponse<JobPostListResponse> postAllJobGetList;

  PostAllJobGetState copyWith({
    ApiResponse<JobPostListResponse>? postAllJobGetList,
  }) {
    return PostAllJobGetState(
      postAllJobGetList: postAllJobGetList ?? this.postAllJobGetList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [postAllJobGetList];
}
