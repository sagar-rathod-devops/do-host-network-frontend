import 'package:do_host/model/user_follow/user_follow_model.dart';
import 'package:do_host/repository/user_follow_api/user_follow_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class UserFollowMockApiRepository implements UserFollowApiRepository {
  @override
  Future<UserFollowModel> userFollowApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'User follow Successful'};
    return UserFollowModel.fromJson(responseData);
  }
}
