import 'package:do_host/model/verify_otp/verify_otp_model.dart';

/// Abstract class defining methods for authentication API repositories.
abstract class VerifyOtpApiRepository {
  /// Sends a login request to the authentication API with the provided [data].
  ///
  /// Returns a [VerifyOTPModel] representing the user data if the login is successful.
  Future<VerifyOTPModel> verifyOTPApi(dynamic data);
}
