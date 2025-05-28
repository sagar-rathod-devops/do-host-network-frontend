import 'package:do_host/model/reset_password/reset_password_model.dart';
import 'package:do_host/repository/reset_password_api/reset_password_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class ResetPasswordHttpApiRepository implements ResetPasswordApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<ResetPasswordModel> resetPasswordApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.resetPasswordEndPoint,
      data,
      headers: {},
    );
    return ResetPasswordModel.fromJson(response);
  }
}
