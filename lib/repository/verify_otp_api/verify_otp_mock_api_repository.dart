import 'package:do_host/model/verify_otp/verify_otp_model.dart';
import 'package:do_host/repository/verify_otp_api/verify_otp_api_repository.dart';

class VerifyOtpMockApiRepository implements VerifyOtpApiRepository {
  @override
  Future<VerifyOTPModel> verifyOTPApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'verified otp successfully'};
    return VerifyOTPModel.fromJson(responseData);
  }
}
