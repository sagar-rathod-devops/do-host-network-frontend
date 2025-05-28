import 'package:do_host/model/register/register_model.dart';

/// Abstract class defining methods for authentication API repositories.
abstract class RegisterApiRepository {
  /// Sends a Register request to the authentication API with the provided [data].
  ///
  /// Returns a [RegisterModel] representing the user data if the login is successful.
  Future<RegisterModel> signupApi(dynamic data);
}
