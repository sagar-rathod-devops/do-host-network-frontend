import 'package:do_host/model/register/register_model.dart';

import '../../data/network/network_api_services.dart';
import '../../model/user/user_model.dart';
import '../../utils/app_url.dart';
import 'register_api_repository.dart';

/// Implementation of [AuthApiRepository] for making HTTP requests to the authentication API.
class RegisterHttpApiRepository implements RegisterApiRepository {
  final _apiServices = NetworkApiService();

  /// Sends a login request to the authentication API with the provided [data].
  ///
  /// Returns a [UserModel] representing the user data if the login is successful.
  @override
  Future<RegisterModel> signupApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.registerEndPoint,
      data,
      headers: {},
    );
    return RegisterModel.fromJson(response);
  }
}
