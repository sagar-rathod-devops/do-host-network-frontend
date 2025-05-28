import 'package:do_host/model/user_education/user_education_model.dart';
import 'package:do_host/repository/user_education_api/user_education_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

class UserEducationHttpApiRepository implements UserEducationApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<UserEducationModel> userEducationApi(dynamic data) async {
    // dynamic response = await _apiServices.postApi(AppUrl.userEducationEndPoint, data, headers: {});
    // return UserEducationModel.fromJson(response);
    try {
      // Fetch token from SessionController
      String? token = await SessionController().getToken();

      if (token == null) {
        throw Exception('Token not found. Please log in.');
      }

      // Add Authorization header
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      // Make the authorized API call
      dynamic response = await _apiServices.postApi(
        AppUrl.userEducationEndPoint,
        data,
        headers: headers,
      );

      return UserEducationModel.fromJson(response);
    } catch (e) {
      // Optionally log the error or rethrow
      rethrow;
    }
  }
}
