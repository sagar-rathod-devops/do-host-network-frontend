import 'package:do_host/repository/user_experience_get_api/user_experience_get_api_repository.dart';
import '../../data/network/network_api_services.dart';
import '../../model/user_experience_get/user_experience_get_model.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

class UserExperienceGetHttpApiRepository
    implements UserExperienceGetApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<UserExperienceListResponse> fetchUserExperienceList(
    String? userId,
  ) async {
    try {
      String? token = await SessionController().getToken();
      // String? userId = await SessionController().getUserId();

      if (token == null || userId == null) {
        throw Exception('Token or User ID not found. Please log in.');
      }

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final String url = "${AppUrl.userExperienceGetEndPoint}/$userId";

      dynamic response = await _apiServices.getApi(url, headers: headers);

      if (response is List) {
        // Convert response list to List<UserExperience>
        final experiences = response
            .map(
              (item) => UserExperience.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        // Return wrapped response
        return UserExperienceListResponse(data: experiences);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }
}
