import 'package:do_host/model/user_unfollow/user_unfollow_model.dart';
import 'package:do_host/repository/user_unfollow_api/user_unfollow_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class UserUnfollowMockApiRepository implements UserUnfollowApiRepository {
  @override
  Future<UserUnfollowModel> userUnfollowApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'User Unfollow Successful'};
    return UserUnfollowModel.fromJson(responseData);
  }
}
