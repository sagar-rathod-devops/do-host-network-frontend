import 'package:do_host/view/profile/user_profile/user_profile_widget.dart';
import 'package:flutter/material.dart';

class AddUserProfileCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final String userId;

  const AddUserProfileCard({
    Key? key,
    required this.message,
    required this.icon,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, size: 40, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfileWidget(userId: userId),
                  ),
                );
              },
              child: const Icon(Icons.add_circle, size: 24, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
