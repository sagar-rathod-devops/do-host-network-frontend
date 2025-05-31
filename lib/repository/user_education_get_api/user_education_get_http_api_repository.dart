import 'package:do_host/repository/user_education_get_api/user_education_get_repository.dart';
import '../../data/network/network_api_services.dart';
import '../../model/user_education_get/user_education_get_model.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

class UserEducationGetHttpApiRepository
    implements UserEducationGetApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<UserEducationListResponse> fetchUserEducationList(
    String? userId,
  ) async {
    try {
      // Fetch token and userId from session
      String? token = await SessionController().getToken();
      // String? userId = await SessionController().getUserId();

      if (token == null || userId == null) {
        throw Exception('Token or User ID not found. Please log in.');
      }

      // Headers
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      // Endpoint
      final String url = "${AppUrl.userEducationGetEndPoint}/$userId";

      // GET request
      dynamic response = await _apiServices.getApi(url, headers: headers);

      // The API returns a JSON array (List), not an object with "data" key
      if (response is List) {
        // Map the list items to UserEducation objects
        final List<UserEducation> educationList = response
            .map((item) => UserEducation.fromJson(item as Map<String, dynamic>))
            .toList();

        // Return a UserEducationListResponse wrapping the list with error=null
        return UserEducationListResponse(error: null, data: educationList);
      } else {
        throw Exception('Unexpected response format: expected a JSON array');
      }
    } catch (e) {
      rethrow;
    }
  }
}
