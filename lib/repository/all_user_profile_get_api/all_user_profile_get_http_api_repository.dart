import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/all_user_profile_get/all_user_profile_get_model.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';
import 'all_user_profile_get_api_repository.dart';

class AllUserProfileGetHttpApiRepository
    implements AllUserProfileGetApiRepository {
  @override
  Future<AllUserProfileResponse> fetchAllUserProfileList() async {
    try {
      final token = await SessionController().getToken();
      if (token == null) {
        throw Exception('Token not found. Please log in.');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final url = AppUrl.allUserProfileGetEndPoint;
      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint('API Status Code: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is List) {
          return AllUserProfileResponse.fromJson(decoded);
        }

        if (decoded is Map<String, dynamic>) {
          if (decoded['data'] is List) {
            return AllUserProfileResponse.fromJson(decoded['data']);
          } else if (decoded['profiles'] is List) {
            return AllUserProfileResponse.fromJson(decoded['profiles']);
          } else {
            throw Exception(
              'Invalid response format: expected a list inside "data" or "profiles".',
            );
          }
        }

        throw Exception('Unexpected response format');
      } else {
        throw Exception(
          'Failed to fetch user profiles. Status code: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Exception occurred while fetching profiles: $e');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    }
  }
}
