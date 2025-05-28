import 'package:do_host/model/post_job/post_job_model.dart';
import 'package:do_host/repository/post_job_api/post_job_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class PostJobMockApiRepository implements PostJobApiRepository {
  @override
  Future<PostJobModel> postJobApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Content Post Successful'};
    return PostJobModel.fromJson(responseData);
  }
}
