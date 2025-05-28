import 'package:do_host/model/post_like/post_like_model.dart';
import 'package:do_host/repository/post_like_api/post_like_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class PostLikeMockApiRepository implements PostLikeApiRepository {
  @override
  Future<PostLikeModel> postLikeApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Post like Successful'};
    return PostLikeModel.fromJson(responseData);
  }
}
