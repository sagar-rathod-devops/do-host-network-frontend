import 'dart:convert';
import 'package:do_host/repository/user_video_get_api/user_video_get_api_repository.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import '../../data/network/network_api_services.dart';
import '../../model/user_video_get/user_video_model.dart';
import '../../utils/app_url.dart';

class UserVideoGetHttpApiRepository implements UserVideoGetApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<List<UserVideoResponse>> fetchUserVideoList(String? userId) async {
    try {
      String? token = await SessionController().getToken();

      if (token == null || userId == null) {
        throw Exception('Token or User ID not found. Please log in.');
      }

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final String url = "${AppUrl.userVideoGetEndPoint}/$userId";

      dynamic response = await _apiServices.getApi(url, headers: headers);

      if (response is List) {
        return response
            .map((json) => UserVideoResponse.fromJson(json))
            .toList();
      } else {
        throw Exception("Expected a list of user videos, got ${response.runtimeType}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
