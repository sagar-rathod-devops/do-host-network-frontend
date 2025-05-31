import 'package:do_host/repository/user_profile_get_api/user_profile_get_api_repository.dart';
import '../../data/network/network_api_services.dart';
import '../../model/user_profile_get/user_profile_get_model.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

/// Implementation of [UserProfileGetApiRepository] for making HTTP requests to fetch user profile data.
class UserProfileGetHttpApiRepository implements UserProfileGetApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<UserProfileResponse> fetchUserProfile(String userId) async {
    try {
      String? token = await SessionController().getToken();

      if (token == null || userId.isEmpty) {
        throw Exception('Token or User ID not found. Please log in.');
      }

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final String url = "${AppUrl.userProfileGetEndPoint}/$userId";

      dynamic response = await _apiServices.getApi(url, headers: headers);

      return UserProfileResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
