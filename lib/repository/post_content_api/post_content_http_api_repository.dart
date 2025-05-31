import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:do_host/model/post_content/post_content_model.dart';
import 'package:do_host/repository/post_content_api/post_content_api_repository.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart'; // For dynamic content type

import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

class PostContentHttpApiRepository implements PostContentApiRepository {
  @override
  Future<PostContentModel> postContentApi(dynamic data) async {
    try {
      final File? imageFile = data['media_file'];
      final Uint8List? mediaBytes = data['media_bytes'];
      final String postContent = data['post_content'] ?? '';

      final token = await SessionController().getToken();
      if (token == null) throw Exception('User token not found');
      final userId = await SessionController().getUserId();
      if (userId == null) throw Exception('User ID not found');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.postsContentEndPoint),
      );
      request.headers['Authorization'] = 'Bearer $token';

      // 🔹 Add multipart file for mobile/desktop (File)
      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path)?.split('/');
        final mediaType = mimeType != null && mimeType.length == 2
            ? MediaType(mimeType[0], mimeType[1])
            : MediaType('image', 'jpeg'); // fallback

        request.files.add(
          await http.MultipartFile.fromPath(
            'media_url',
            imageFile.path,
            contentType: mediaType,
          ),
        );
      }

      // 🔹 Add multipart bytes for web (Uint8List)
      if (mediaBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'media_url',
            mediaBytes,
            filename: 'upload.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      // 🔹 Add form fields
      request.fields['user_id'] = userId;
      request.fields['post_content'] = postContent;

      final streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        final jsonResponse = json.decode(responseString);
        return PostContentModel.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to post content: $responseString");
      }
    } catch (e) {
      rethrow;
    }
  }
}
