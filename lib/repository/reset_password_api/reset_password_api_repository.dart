import '../../model/reset_password/reset_password_model.dart';

abstract class ResetPasswordApiRepository {
  Future<ResetPasswordModel> resetPasswordApi(dynamic data);
}
