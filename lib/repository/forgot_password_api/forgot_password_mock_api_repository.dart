import 'package:do_host/model/forgot_password/forgot_password_model.dart';
import 'package:do_host/repository/forgot_password_api/forgot_password_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class ForgotPasswordMockApiRepository implements ForgotPasswordApiRepository {
  @override
  Future<ForgotPasswordModel> forgotPasswordApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Forgot Password'};
    return ForgotPasswordModel.fromJson(responseData);
  }
}
