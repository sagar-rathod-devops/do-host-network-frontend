import 'package:do_host/model/notifications_create/notifications_create_model.dart';
import 'package:do_host/repository/notifications_create_api/notifications_create_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating login requests.
class NotificationsCreateMockApiRepository
    implements NotificationsCreateApiRepository {
  @override
  Future<NotificationsCreateModel> notificationsCreateApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(const Duration(seconds: 2));
    // Mock response data
    var responseData = {'message': 'Notifications Create'};
    return NotificationsCreateModel.fromJson(responseData);
  }
}
