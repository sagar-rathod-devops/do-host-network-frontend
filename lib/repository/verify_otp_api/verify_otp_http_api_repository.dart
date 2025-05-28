import 'package:do_host/model/verify_otp/verify_otp_model.dart';
import 'package:do_host/repository/verify_otp_api/verify_otp_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../model/user/user_model.dart';
import '../../utils/app_url.dart';

/// Implementation of [AuthApiRepository] for making HTTP requests to the authentication API.
class VerifyOtpHttpApiRepository implements VerifyOtpApiRepository {
  final _apiServices = NetworkApiService();

  /// Sends a login request to the authentication API with the provided [data].
  ///
  /// Returns a [UserModel] representing the user data if the login is successful.
  @override
  Future<VerifyOTPModel> verifyOTPApi(dynamic data) async {
    print("Sagar Data: ${data.toString()}");
    dynamic response = await _apiServices.postApi(
      AppUrl.verifyOTPEndPoint,
      data,
      headers: {},
    );
    return VerifyOTPModel.fromJson(response);
  }
}
