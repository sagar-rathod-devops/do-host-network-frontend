import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:do_host/model/user_profile/user_profile_model.dart';
import 'package:do_host/repository/user_profile_api/user_profile_api_repository.dart';

import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';

class UserProfileHttpApiRepository implements UserProfileApiRepository {
  @override
  Future<UserProfileModel> userProfileApi(
    dynamic data,
    File? profileImage,
  ) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('Token not found. Please log in.');

      final userId = await SessionController().getUserId();
      if (userId == null) throw Exception('User ID not found');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.userProfileEndPoint),
      );

      // Set Authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Attach profile image if available
      if (profileImage != null && profileImage.existsSync()) {
        final mimeType = lookupMimeType(profileImage.path)?.split('/');
        final mediaType = mimeType != null && mimeType.length == 2
            ? MediaType(mimeType[0], mimeType[1])
            : MediaType('image', 'jpeg'); // default fallback

        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            profileImage.path,
            contentType: mediaType,
          ),
        );
      }

      // Add form fields
      request.fields['user_id'] = userId;
      request.fields['full_name'] = data['full_name'] ?? '';
      request.fields['designation'] = data['designation'] ?? '';
      request.fields['organization'] = data['organization'] ?? '';
      request.fields['professional_summary'] =
          data['professional_summary'] ?? '';
      request.fields['location'] = data['location'] ?? '';
      request.fields['email'] = data['email'] ?? '';
      request.fields['contact_number'] = data['contact_number'] ?? '';

      final streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        final jsonResponse = json.decode(responseString);
        return UserProfileModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to update profile: $responseString');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> userProfileUpdateApi(
    dynamic data,
    File? profileImage,
  ) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('Token not found. Please log in.');

      final userId = await SessionController().getUserId();
      if (userId == null) throw Exception('User ID not found');

      final uri = Uri.parse("${AppUrl.baseUrl}/user/profile/update/$userId");

      final request = http.MultipartRequest('PUT', uri);

      // Authorization
      request.headers['Authorization'] = 'Bearer $token';

      // Attach image if available
      if (profileImage != null && profileImage.existsSync()) {
        final mimeType = lookupMimeType(profileImage.path)?.split('/');
        final mediaType = mimeType != null && mimeType.length == 2
            ? MediaType(mimeType[0], mimeType[1])
            : MediaType('image', 'jpeg');

        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            profileImage.path,
            contentType: mediaType,
          ),
        );
      }

      // Add fields
      request.fields['user_id'] = userId;
      request.fields['full_name'] = data['full_name'] ?? '';
      request.fields['designation'] = data['designation'] ?? '';
      request.fields['organization'] = data['organization'] ?? '';
      request.fields['professional_summary'] =
          data['professional_summary'] ?? '';
      request.fields['location'] = data['location'] ?? '';
      request.fields['email'] = data['email'] ?? '';
      request.fields['contact_number'] = data['contact_number'] ?? '';

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        final jsonResponse = json.decode(responseBody);
        return UserProfileModel.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to update profile: $responseBody");
      }
    } catch (e) {
      rethrow;
    }
  }
}
