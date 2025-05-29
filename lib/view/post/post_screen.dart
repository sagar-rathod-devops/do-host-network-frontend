import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  final String initialPostType; // "user" or "job"

  const PostScreen({super.key, required this.initialPostType});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late String selectedPostType;

  @override
  void initState() {
    super.initState();
    selectedPostType = widget.initialPostType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  ToggleButtons(
                    isSelected: [
                      selectedPostType == 'user',
                      selectedPostType == 'job',
                    ],
                    onPressed: (int index) {
                      setState(() {
                        selectedPostType = index == 0 ? 'user' : 'job';
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    fillColor: Colors.blue,
                    color: Colors.black,
                    constraints: const BoxConstraints(
                      minHeight: 40,
                      minWidth: 150,
                    ),
                    children: const [Text("Content Post"), Text("Job Post")],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      alignment: Alignment.center,
                      child: selectedPostType == 'user'
                          ? const Text(
                              "Content",
                              style: TextStyle(fontSize: 24),
                            )
                          : const Text("Job", style: TextStyle(fontSize: 24)),
                    ),
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
