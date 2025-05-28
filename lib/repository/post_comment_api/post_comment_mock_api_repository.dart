import 'package:do_host/model/post_comment/post_comment_model.dart';
import 'package:do_host/repository/post_comment_api/post_comment_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class PostCommentMockApiRepository implements PostCommentApiRepository {
  @override
  Future<PostCommentModel> postCommentApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Post Comment Successful'};
    return PostCommentModel.fromJson(responseData);
  }
}
