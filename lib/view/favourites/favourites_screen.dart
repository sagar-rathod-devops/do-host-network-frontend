import 'package:flutter/material.dart';
import 'favourite_detail_screen.dart'; // Import the detail screen

class FavouritesScreen extends StatelessWidget {
  final String? userId;
  const FavouritesScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        child: ListView(
          children: [
            _buildFavouriteCard(
              context,
              title: 'New Comment on Your Post',
              description: 'John Doe commented on your post.',
              timestamp: '5 minutes ago',
              color: Colors.blue,
            ),
            _buildFavouriteCard(
              context,
              title: 'Action Completed Successfully',
              description: 'Your account has been verified.',
              timestamp: '1 hour ago',
              color: Colors.green,
            ),
            _buildFavouriteCard(
              context,
              title: 'Error with Your Request',
              description: 'There was an issue processing your payment.',
              timestamp: '3 hours ago',
              color: Colors.red,
            ),
            _buildFavouriteCard(
              context,
              title: 'App Update Available',
              description:
                  'A new version of the app is available for download.',
              timestamp: 'Yesterday',
              color: Colors.orange,
            ),
            _buildFavouriteCard(
              context,
              title: 'New Message Received',
              description: 'You have received a new message from Sarah.',
              timestamp: '2 days ago',
              color: Colors.purple,
            ),
            _buildFavouriteCard(
              context,
              title: 'Upcoming Event',
              description: 'Don’t forget the meeting tomorrow at 10:00 AM.',
              timestamp: '3 days ago',
              color: Colors.teal,
            ),
            _buildFavouriteCard(
              context,
              title: 'New Follower',
              description: 'Alice started following you.',
              timestamp: '4 days ago',
              color: Colors.pink,
            ),
            _buildFavouriteCard(
              context,
              title: 'Promotion Alert',
              description: 'Get 20% off your next purchase!',
              timestamp: '5 days ago',
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavouriteCard(
    BuildContext context, {
    required String title,
    required String description,
    required String timestamp,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to the detail screen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavouriteDetailScreen(
              title: title,
              description: description,
              timestamp: timestamp,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(description),
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
