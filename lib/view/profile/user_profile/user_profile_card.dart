import 'package:flutter/material.dart';
import 'package:do_host/view/profile/user_profile/user_profile_widget.dart';

class UserProfileCard extends StatelessWidget {
  final dynamic profile; // Replace `dynamic` with your strongly-typed model.
  final String userId;

  const UserProfileCard({Key? key, required this.profile, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile image and basic info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage:
                            (profile.profileImage?.isNotEmpty ?? false)
                            ? NetworkImage(profile.profileImage)
                            : null,
                        child: (profile.profileImage?.isEmpty ?? true)
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.fullName ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.badge,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    profile.designation ?? '',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    profile.location ?? '',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Email
                  Row(
                    children: [
                      const Icon(Icons.email, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          profile.email ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Phone
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        profile.contactNumber ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  /// Professional Summary
                  const Text(
                    "Professional Summary:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.professionalSummary ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 12),

                  /// Organization (optional)
                  if ((profile.organization?.isNotEmpty ?? false))
                    Row(
                      children: [
                        const Icon(
                          Icons.business,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          profile.organization,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          /// Edit Button
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfileWidget(userId: userId),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
                child: const Icon(Icons.edit, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
