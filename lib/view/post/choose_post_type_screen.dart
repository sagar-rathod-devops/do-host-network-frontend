import 'package:do_host/configs/color/color.dart';
import 'package:do_host/view/post/content_post/post_content_widget.dart';
import 'package:flutter/material.dart';

import 'job_post/job_post_widget.dart';

class ChoosePostTypeScreen extends StatelessWidget {
  final String? userId;
  const ChoosePostTypeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Post Type',
          style: TextStyle(color: Colors.white), // white title text
        ),
        backgroundColor: AppColors.buttonColor, // deep orange background
        iconTheme: const IconThemeData(color: Colors.white), // back icon color
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double contentWidth = constraints.maxWidth;
          double maxContentWidth;

          if (contentWidth < 600) {
            maxContentWidth = contentWidth; // Mobile
          } else if (contentWidth < 1100) {
            maxContentWidth = 600; // Tablet/Web Small
          } else {
            maxContentWidth = 800; // Desktop/Web Large
          }

          return Center(
            child: Container(
              width: maxContentWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.text_fields,
                      color: Colors.white,
                    ), // icon color
                    label: const Text(
                      'Content Post',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor, // button color
                      minimumSize: const Size(
                        double.infinity,
                        50,
                      ), // full width button
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostContentWidget(userId: userId!),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.work, color: Colors.white),
                    label: const Text(
                      'Job Post',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      minimumSize: const Size(
                        double.infinity,
                        50,
                      ), // full width button
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobPostWidget(userId: userId!),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
