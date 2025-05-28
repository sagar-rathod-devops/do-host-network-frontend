import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/post_all_content_get/post_model.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';
import 'post_all_content_get_api_repository.dart';

class PostAllContentGetHttpApiRepository
    implements PostAllContentGetApiRepository {
  @override
  Future<PostResponse> fetchPostAllContentList() async {
    try {
      final token = await SessionController().getToken();
      if (token == null) {
        throw Exception('Token not found. Please log in.');
      }

      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final url = AppUrl.postsAllContentEndPoint;
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is List) {
          // response is a list of posts directly
          final posts = responseData
              .map(
                (postJson) => Post.fromJson(postJson as Map<String, dynamic>),
              )
              .toList();
          return PostResponse(posts: posts);
        } else if (responseData is Map<String, dynamic>) {
          // response is an object wrapping posts
          return PostResponse.fromJson(responseData);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
          'Failed to load posts. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching posts: $e');
      rethrow;
    }
  }
}
