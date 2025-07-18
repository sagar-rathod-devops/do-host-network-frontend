import 'package:do_host/repository/post_all_job_get_api/post_all_job_get_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../model/movie_list/movie_list_model.dart';
import '../../model/post_all_job_get/job_post_model.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

/// Implementation of [MoviesApiRepository] for making HTTP requests to fetch movies list.
class PostAllJobGetHttpApiRepository implements PostAllJobGetApiRepository {
  final _apiServices = NetworkApiService();

  /// Fetches the list of movies from the API.
  ///
  /// Returns a [MovieListModel] representing the list of movies.
  @override
  Future<JobPostListResponse> fetchPostAllJobList() async {
    // final response = await _apiServices.getApi(AppUrl.postsAllJobGetEndPoint, headers: {});
    // return JobPostListResponse.fromJson(response);
    try {
      // Fetch token and userId from session
      String? token = await SessionController().getToken();
      // String? userId = await SessionController().getUserId();

      if (token == null) {
        throw Exception('Token or User ID not found. Please log in.');
      }

      // Headers
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      // Endpoint
      final String url = "${AppUrl.postsAllJobGetEndPoint}";

      // GET request
      dynamic response = await _apiServices.getApi(url, headers: headers);

      // The API returns a JSON array (List), not an object with "data" key
      if (response is List) {
        // Map the list items to UserEducation objects
        final List<JobPost> educationList = response
            .map((item) => JobPost.fromJson(item as Map<String, dynamic>))
            .toList();

        // Return a UserEducationListResponse wrapping the list with error=null
        return JobPostListResponse(error: null, data: educationList);
      } else {
        throw Exception('Unexpected response format: expected a JSON array');
      }
    } catch (e) {
      rethrow;
    }
  }
}
