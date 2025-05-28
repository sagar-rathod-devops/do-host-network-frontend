import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/app_icon.png', // Local image path
        width: 100, // Set the desired width of the circle
        height: 100, // Set the desired height of the circle
        fit: BoxFit
            .cover, // Ensures the image covers the circle area without distortion
      ),
    );
  }
}
