import 'package:do_host/repository/user_video_get_api/user_video_get_api_repository.dart';
import 'package:do_host/services/session_manager/session_controller.dart';

import '../../data/network/network_api_services.dart';
import '../../model/movie_list/movie_list_model.dart';
import '../../model/user_video_get/user_video_model.dart';
import '../../utils/app_url.dart';

/// Implementation of [MoviesApiRepository] for making HTTP requests to fetch movies list.
class UserVideoGetHttpApiRepository implements UserVideoGetApiRepository {
  final _apiServices = NetworkApiService();

  /// Fetches the list of movies from the API.
  ///
  /// Returns a [MovieListModel] representing the list of movies.
  @override
  Future<UserVideoResponse> fetchUserVideoList() async {
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
      final String url = "${AppUrl.userVideoGetEndPoint}/$userId";

      // Perform GET request
      dynamic response = await _apiServices.getApi(url, headers: headers);

      // Parse and return the response
      return UserVideoResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
