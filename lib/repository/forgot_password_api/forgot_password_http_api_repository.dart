import 'package:do_host/model/forgot_password/forgot_password_model.dart';
import 'package:do_host/repository/forgot_password_api/forgot_password_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class ForgotPasswordHttpApiRepository implements ForgotPasswordApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<ForgotPasswordModel> forgotPasswordApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.forgotPasswordEndPoint,
      data,
      headers: {},
    );
    return ForgotPasswordModel.fromJson(response);
  }
}
