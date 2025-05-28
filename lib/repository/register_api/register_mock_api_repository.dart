import 'package:do_host/model/register/register_model.dart';

import 'register_api_repository.dart';

class RegisterMockApiRepository implements RegisterApiRepository {
  @override
  Future<RegisterModel> signupApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'register successful'};
    return RegisterModel.fromJson(responseData);
  }
}
