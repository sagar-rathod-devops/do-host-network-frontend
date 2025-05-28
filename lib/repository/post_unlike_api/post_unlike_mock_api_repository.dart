import 'package:do_host/model/post_unlike/post_unlike_model.dart';
import 'package:do_host/repository/post_unlike_api/post_unlike_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class PostUnlikeMockApiRepository implements PostUnlikeApiRepository {
  @override
  Future<PostUnlikeModel> postUnlikeApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Post unlike Successful'};
    return PostUnlikeModel.fromJson(responseData);
  }
}
