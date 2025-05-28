import 'package:do_host/model/forgot_password/forgot_password_model.dart';

abstract class ForgotPasswordApiRepository {
  Future<ForgotPasswordModel> forgotPasswordApi(dynamic data);
}
