import 'dart:convert';
import 'dart:io';

import 'package:do_host/model/user_video/user_video_model.dart';
import 'package:do_host/repository/user_video_api/user_video_api_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

class UserVideoHttpApiRepository implements UserVideoApiRepository {
  @override
  Future<UserVideoModel> userVideoApi(dynamic data) async {
    try {
      final File? videoFile = data['video_file'];
      final String? userId = data['user_id'];

      if (userId == null || userId.isEmpty) {
        throw Exception("User ID is required.");
      }

      final token = await SessionController().getToken();
      if (token == null) throw Exception('User token not found');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.userVideoEndPoint),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add video file if present
      if (videoFile != null) {
        final mimeType = lookupMimeType(videoFile.path)?.split('/');
        final mediaType = mimeType != null && mimeType.length == 2
            ? MediaType(mimeType[0], mimeType[1])
            : MediaType('video', 'mp4'); // fallback

        request.files.add(
          await http.MultipartFile.fromPath(
            'video', // 🔁 make sure this matches backend key
            videoFile.path,
            contentType: mediaType,
          ),
        );
      } else {
        throw Exception("Video file is required.");
      }

      // Add user_id field
      request.fields['user_id'] = userId;

      final streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();

      print("Response Code: ${streamedResponse.statusCode}");
      print("Response Body: $responseString");

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        final jsonResponse = json.decode(responseString);
        return UserVideoModel.fromJson(jsonResponse);
      } else {
        throw Exception(
          "Upload failed: ${streamedResponse.statusCode} - $responseString",
        );
      }
    } catch (e) {
      print("Error in userVideoApi: $e");
      rethrow;
    }
  }
}
