import 'package:do_host/model/user_experience/user_experience_model.dart';
import 'package:do_host/repository/user_experience_api/user_experience_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

class UserExperienceHttpApiRepository implements UserExperienceApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<UserExperienceModel> userExperienceApi(dynamic data) async {
    // dynamic response = await _apiServices.postApi(AppUrl.userExperienceEndPoint, data, headers: {});
    // return UserExperienceModel.fromJson(response);
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
        AppUrl.userExperienceEndPoint,
        data,
        headers: headers,
      );

      return UserExperienceModel.fromJson(response);
    } catch (e) {
      // Optionally log the error or rethrow
      rethrow;
    }
  }
}
