import 'package:do_host/model/user_video/user_video_model.dart';
import 'package:do_host/repository/user_video_api/user_video_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class UserVideoMockApiRepository implements UserVideoApiRepository {
  @override
  Future<UserVideoModel> userVideoApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'User Video Successful'};
    return UserVideoModel.fromJson(responseData);
  }
}
