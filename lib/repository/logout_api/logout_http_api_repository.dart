import 'package:do_host/model/logout/logout_model.dart';
import 'package:do_host/repository/logout_api/logout_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class LogoutHttpApiRepository implements LogoutApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<LogoutModel> logoutApi() async {
    dynamic response = await _apiServices.getApi(
      AppUrl.logoutEndPoint,
      headers: {},
    );
    return LogoutModel.fromJson(response);
  }
}
