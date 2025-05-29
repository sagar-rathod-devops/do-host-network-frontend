import 'package:do_host/configs/color/color.dart';
import 'package:flutter/material.dart';

class FavouriteDetailScreen extends StatelessWidget {
  final String description;
  final String timestamp;

  const FavouriteDetailScreen({
    super.key,
    required this.description,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Device type breakpoints
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;

    final double maxContentWidth = isMobile
        ? screenWidth
        : isTablet
        ? 600
        : 800;

    // Extract the first URL in the text
    final uriRegex = RegExp(r'(https?:\/\/[^\s]+)');
    final match = uriRegex.firstMatch(description);
    final imageUrl = match?.group(0);

    // Split message text around the image URL
    String beforeUrl = '';
    String afterUrl = '';
    if (imageUrl != null) {
      final parts = description.split(imageUrl);
      beforeUrl = parts[0].trim();
      afterUrl = parts.length > 1 ? parts[1].trim() : '';
    } else {
      beforeUrl = description;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        iconTheme: const IconThemeData(color: AppColors.whiteColor), // <-- here
        title: const Text(
          "Notification Details",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Align(
        alignment: Alignment
            .topCenter, // Align content horizontally center and top vertically
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (beforeUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      beforeUrl,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                if (imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: isMobile
                            ? 200
                            : isTablet
                            ? 300
                            : 400,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text("Failed to load image"),
                      ),
                    ),
                  ),
                if (afterUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(afterUrl, style: const TextStyle(fontSize: 16)),
                  ),
                Text(
                  'Timestamp: $timestamp',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
