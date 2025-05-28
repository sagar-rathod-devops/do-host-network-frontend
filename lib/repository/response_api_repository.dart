import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../services/session_manager/session_controller.dart';
import '../../utils/app_url.dart';
import '../../data/network/network_api_services.dart';

class ResponseApiRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<void> likePost(String postId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.likePost}/$postId/like";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.postApi(url, null, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.likePost}/$postId/unlike";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.postApi(url, null, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getLikedPostIds(String userId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.likePost}/$userId/likes";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _apiService.getApi(url, headers: headers);
      final List<dynamic> likedPosts = response['likes'] ?? [];
      return likedPosts.cast<String>();
    } catch (e) {
      debugPrint("Error fetching liked post IDs: $e");
      return [];
    }
  }

  Future<void> postComment(String postId, String comment) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.commentPost}/$postId/comment";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = {'comment': comment};

      await _apiService.postApi(url, body, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getComments(String postId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.commentPost}/$postId/comments";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _apiService.getApi(url, headers: headers);

      if (response is List) {
        return response.cast<String>();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> followUser(String followedId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.followUser}/$followedId/follow";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.postApi(url, null, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unfollowUser(String followedId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.followUser}/$followedId/unfollow";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.postApi(url, null, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getFollowedUserIds(String userId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.baseUrl}/user/$userId/followings";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _apiService.getApi(url, headers: headers);

      final List<dynamic> followings = response['followings'] ?? [];
      return followings.cast<String>();
    } catch (e) {
      debugPrint("Error fetching followed users: $e");
      return [];
    }
  }

  // ========================= DELETE APIs =========================

  Future<void> deleteUserVideo(String videoId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.baseUrl}/user/video/$videoId";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.deleteApi(url, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserEducation(String educationId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.baseUrl}/user/education/$educationId";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.deleteApi(url, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserExperience(String experienceId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.baseUrl}/user/experience/$experienceId";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.deleteApi(url, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserProfile(String userId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.baseUrl}/user/profile/delete/$userId";
      debugPrint("DELETE URL: $url");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.deleteApi(url, headers: headers);
    } catch (e) {
      rethrow;
    }
  }
}
