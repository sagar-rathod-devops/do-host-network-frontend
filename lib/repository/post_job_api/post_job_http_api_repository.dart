import 'package:do_host/model/post_job/post_job_model.dart';
import 'package:do_host/repository/post_job_api/post_job_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

class PostJobHttpApiRepository implements PostJobApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<PostJobModel> postJobApi(dynamic data) async {
    // dynamic response = await _apiServices.postApi(AppUrl.postsJobEndPoint, data, headers: {});
    // return PostJobModel.fromJson(response);
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
        AppUrl.postsJobEndPoint,
        data,
        headers: headers,
      );

      return PostJobModel.fromJson(response);
    } catch (e) {
      // Optionally log the error or rethrow
      rethrow;
    }
  }
}
