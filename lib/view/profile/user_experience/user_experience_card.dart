import 'package:do_host/model/user_experience_get/user_experience_get_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Make sure you import your UserExperience model here
// import 'path_to_user_experience_model.dart';

class UserExperienceCardList extends StatelessWidget {
  final List<UserExperience> experiences;
  final void Function(String id) onDeleteSuccess;

  const UserExperienceCardList({
    Key? key,
    required this.experiences,
    required this.onDeleteSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (experiences.isEmpty) {
      return const Center(child: Text('No Experience Data Available'));
    }

    // Sort by startDate descending
    final sortedExperiences = List<UserExperience>.from(experiences);
    sortedExperiences.sort((a, b) {
      if (a.startDate == null && b.startDate == null) return 0;
      if (a.startDate == null) return 1;
      if (b.startDate == null) return -1;
      return b.startDate!.compareTo(a.startDate!);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedExperiences.length,
      itemBuilder: (context, index) {
        final exp = sortedExperiences[index];
        final startDate = exp.startDate != null
            ? DateFormat.yMMM().format(exp.startDate!)
            : 'N/A';
        final endDate = exp.endDate != null
            ? DateFormat.yMMM().format(exp.endDate!)
            : 'Present';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Container(
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
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Delete button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.work,
                              color: Colors.blue,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                exp.jobTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: Text(
                                "Are you sure you want to delete ${exp.jobTitle}?",
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                ),
                                ElevatedButton(
                                  child: const Text("Delete"),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            onDeleteSuccess(exp.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Deleted: ${exp.jobTitle}"),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.business, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        exp.companyName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  DefaultTextStyle.merge(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            exp.location,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$startDate - $endDate",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Job Description:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exp.jobDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),

                  const SizedBox(height: 16),

                  if (exp.achievements.isNotEmpty) ...[
                    const Text(
                      "Achievements:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exp.achievements,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
