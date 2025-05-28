import '../../data/network/network_api_services.dart';
import '../../model/user/user_model.dart';
import '../../utils/app_url.dart';
import 'auth_api_repository.dart';

/// Implementation of [AuthApiRepository] for making HTTP requests to the authentication API.
class AuthHttpApiRepository implements AuthApiRepository {
  final _apiServices = NetworkApiService();

  /// Sends a login request to the authentication API with the provided [data].
  ///
  /// Returns a [UserModel] representing the user data if the login is successful.
  @override
  Future<UserModel> loginApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.loginEndPoint,
      data,
      headers: {},
    );
    return UserModel.fromJson(response);
  }
}
