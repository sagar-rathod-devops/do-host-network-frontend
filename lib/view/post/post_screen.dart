import 'package:flutter/material.dart';
// import 'package:do_host_network/view/post/job_post_screen.dart';
// import 'package:do_host_network/view/post/user_post_screen.dart';

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
      body: Column(
        children: [
          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: [selectedPostType == 'user', selectedPostType == 'job'],
            onPressed: (int index) {
              setState(() {
                selectedPostType = index == 0 ? 'user' : 'job';
              });
            },
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            fillColor: Colors.blue,
            color: Colors.black,
            constraints: const BoxConstraints(minHeight: 40, minWidth: 150),
            children: const [Text("Content Post"), Text("Job Post")],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: selectedPostType == 'user'
                ? const Text("Content")
                : const Text("Job"),
          ),
        ],
      ),
    );
  }
}
