import 'package:do_host/repository/user_profile_get_api/user_profile_get_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../model/user_profile_get/user_profile_get_model.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

/// Implementation of [UserProfileGetApiRepository] for making HTTP requests to fetch user profile data.
class UserProfileGetHttpApiRepository implements UserProfileGetApiRepository {
  final _apiServices = NetworkApiService();

  /// Fetches the user profile from the API.
  @override
  Future<UserProfileResponse> fetchUserProfileList() async {
    try {
      // Fetch token and userId from session
      String? token = await SessionController().getToken();
      String? userId = await SessionController().getUserId();

      if (token == null || userId == null) {
        throw Exception('Token or User ID not found. Please log in.');
      }

      // Add Authorization headers
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      // Build complete endpoint URL
      final String url = "${AppUrl.userProfileGetEndPoint}/$userId";

      // Perform GET request
      dynamic response = await _apiServices.getApi(url, headers: headers);

      // Parse and return the response
      return UserProfileResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
