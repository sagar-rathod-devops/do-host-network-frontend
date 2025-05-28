import 'package:do_host/bloc/post_content_bloc/post_content_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostContentInputWidget extends StatefulWidget {
  const PostContentInputWidget({super.key});

  @override
  State<PostContentInputWidget> createState() => _PostContentInputWidgetState();
}

class _PostContentInputWidgetState extends State<PostContentInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _postContentController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _postContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostContentBloc, PostContentState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _postContentController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.text_fields),
              labelText: "Post Content",
              helperText: "Write your post content here",
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null, // Allows multiline input
            textInputAction: TextInputAction.newline,
            onChanged: (value) {
              context.read<PostContentBloc>().add(
                PostContentChanged(postContent: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter some content';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
