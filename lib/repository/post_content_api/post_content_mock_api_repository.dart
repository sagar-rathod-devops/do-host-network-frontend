import 'package:do_host/model/post_content/post_content_model.dart';
import 'package:do_host/repository/post_content_api/post_content_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class PostContentMockApiRepository implements PostContentApiRepository {
  @override
  Future<PostContentModel> postContentApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Content Post Successful'};
    return PostContentModel.fromJson(responseData);
  }
}
