import 'dart:io';
import 'package:do_host/configs/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../bloc/post_content_bloc/post_content_bloc.dart';
import '../../../../data/response/status.dart';

class MediaUrlWidget extends StatefulWidget {
  const MediaUrlWidget({Key? key}) : super(key: key);

  @override
  _MediaUrlWidgetState createState() => _MediaUrlWidgetState();
}

class _MediaUrlWidgetState extends State<MediaUrlWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      context.read<PostContentBloc>().add(
        MediaUrlChanged(mediaFile: _selectedImage!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedImage != null)
          Image.file(
            _selectedImage!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ElevatedButton.icon(
          icon: const Icon(Icons.upload),
          label: const Text("Choose Image"),
          onPressed: () => _pickImage(context),
        ),
        BlocConsumer<PostContentBloc, PostContentState>(
          listener: (context, state) {
            if (state.postApiResponse.status == Status.error &&
                state.postApiResponse.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.postApiResponse.message!)),
              );
            }

            if (state.postApiResponse.status == Status.completed &&
                state.postApiResponse.message == "Post created successfully") {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.myHome,
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return const SizedBox(); // or return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
