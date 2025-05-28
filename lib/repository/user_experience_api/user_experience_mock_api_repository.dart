import 'package:do_host/model/user_experience/user_experience_model.dart';
import 'package:do_host/repository/user_experience_api/user_experience_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class UserExperienceMockApiRepository implements UserExperienceApiRepository {
  @override
  Future<UserExperienceModel> userExperienceApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Post user experience Successful'};
    return UserExperienceModel.fromJson(responseData);
  }
}
