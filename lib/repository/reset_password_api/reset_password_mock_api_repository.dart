import 'package:do_host/model/reset_password/reset_password_model.dart';
import 'package:do_host/repository/reset_password_api/reset_password_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class ResetPasswordMockApiRepository implements ResetPasswordApiRepository {
  @override
  Future<ResetPasswordModel> resetPasswordApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Reset Password'};
    return ResetPasswordModel.fromJson(responseData);
  }
}
