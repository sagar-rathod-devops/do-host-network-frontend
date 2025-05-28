import 'package:do_host/model/post_all_job_get/job_post_model.dart';

abstract class PostAllJobGetApiRepository {
  Future<JobPostListResponse> fetchPostAllJobList();
}
