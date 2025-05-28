import '../../model/logout/logout_model.dart';

abstract class LogoutApiRepository {
  Future<LogoutModel> logoutApi();
}
