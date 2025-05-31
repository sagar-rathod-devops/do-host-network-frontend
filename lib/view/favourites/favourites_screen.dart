import 'dart:convert';

import 'package:do_host/configs/color/color.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import 'package:do_host/utils/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'favourite_detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  // final String userId;

  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final token = await SessionController().getToken();
      final userId = await SessionController().getUserId();
      if (token == null) throw Exception('No token found');

      final url = '${AppUrl.baseUrl}/notifications/${userId}';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          notifications = responseData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTimeAgo(String timestamp) {
    final now = DateTime.now().toUtc();
    final createdAt = DateTime.parse(timestamp).toUtc();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    }
    if (diff.inDays == 1) return 'yesterday';
    return '${diff.inDays} days ago';
  }

  // Color getColorByType(String type) {
  //   switch (type) {
  //     case 'like':
  //       return Colors.blue;
  //     case 'comment':
  //       return Colors.green;
  //     case 'follow':
  //       return Colors.purple;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final double contentWidth = MediaQuery.of(context).size.width;
    final double maxContentWidth = contentWidth < 600
        ? contentWidth
        : contentWidth < 1100
        ? 600
        : 800;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: isLoading
                ? const Center(
                    child: SpinKitSpinningLines(
                      color: AppColors.buttonColor,
                      size: 50.0,
                    ),
                  )
                : notifications.isEmpty
                ? const Center(child: Text('No notifications'))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildFavouriteCard(
                        context,
                        userId: notification['sender_user_id'],
                        description: notification['message'] ?? '',
                        timestamp: notification['created_at'] != null
                            ? formatTimeAgo(notification['created_at'])
                            : '',
                        // color: getColorByType(notification['type'] ?? ''),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavouriteCard(
    BuildContext context, {
    required String description,
    required String timestamp,
    required String userId,
    // required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavouriteDetailScreen(
              description: description,
              timestamp: timestamp,
              userId: userId,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getShortText(description), // `description` is your full string
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                timestamp,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getShortText(String text) {
  const keyword = "your post";
  final lowerText = text.toLowerCase();
  final keywordIndex = lowerText.indexOf(keyword);

  if (keywordIndex != -1) {
    // Include 'your post' fully
    final endIndex = keywordIndex + keyword.length;
    return '${text.substring(0, endIndex)}...';
  }

  return text;
}
