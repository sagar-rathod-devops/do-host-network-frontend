import 'package:do_host/model/user_education_get/user_education_get_model.dart';
import 'package:flutter/material.dart';

class UserEducationCardList extends StatelessWidget {
  final List<UserEducation> educationList;
  final void Function(String id) onDeleteSuccess;

  const UserEducationCardList({
    Key? key,
    required this.educationList,
    required this.onDeleteSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a copy to avoid mutating original list
    final sortedList = [...educationList]
      ..sort((a, b) => b.year.compareTo(a.year));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedList.length,
      itemBuilder: (context, index) {
        final edu = sortedList[index];

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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Degree + Field + Delete
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${edu.degree} in ${edu.fieldOfStudy}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
                                "Are you sure you want to delete ${edu.degree}?",
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
                            onDeleteSuccess(edu.id);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Institution
                  Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        size: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          edu.institutionName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Year + Grade
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Year: ${edu.year}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.grade, size: 18, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        "Grade: ${edu.grade}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
