import 'package:do_host/model/user_education/user_education_model.dart';
import 'package:do_host/repository/user_education_api/user_education_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class UserEducationMockApiRepository implements UserEducationApiRepository {
  @override
  Future<UserEducationModel> userEducationApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Post user education Successful'};
    return UserEducationModel.fromJson(responseData);
  }
}
