import '../../model/notifications_create/notifications_create_model.dart';

abstract class NotificationsCreateApiRepository {
  Future<NotificationsCreateModel> notificationsCreateApi(dynamic data);
}
