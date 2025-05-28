import 'package:do_host/model/notifications_create/notifications_create_model.dart';
import 'package:do_host/repository/notifications_create_api/notifications_create_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class NotificationsCreateHttpApiRepository
    implements NotificationsCreateApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<NotificationsCreateModel> notificationsCreateApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.forgotPasswordEndPoint,
      data,
      headers: {},
    );
    return NotificationsCreateModel.fromJson(response);
  }
}
