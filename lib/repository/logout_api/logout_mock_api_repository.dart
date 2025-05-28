import 'package:do_host/model/logout/logout_model.dart';
import 'package:do_host/repository/logout_api/logout_api_repository.dart';

class LogoutMockApiRepository implements LogoutApiRepository {
  @override
  Future<LogoutModel> logoutApi() async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Logout Successful'};
    return LogoutModel.fromJson(responseData);
  }
}
