import 'dart:io';
import 'package:do_host/data/response/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../bloc/user_profile_bloc/user_profile_bloc.dart';

class UploadImageWidget extends StatefulWidget {
  const UploadImageWidget({Key? key}) : super(key: key);

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      context.read<UserProfileBloc>().add(
        ProfileImageChanged(profileImage: _selectedImage!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedImage != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: Image.file(
              _selectedImage!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ElevatedButton.icon(
          icon: const Icon(Icons.upload),
          label: const Text("Choose Image"),
          onPressed: () => _pickImage(context),
        ),
        BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state.userProfileApi.status == Status.completed &&
                !state.hasShownSuccessMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Image uploaded successfully!')),
              );

              // Set flag true so it doesn’t show again
              context.read<UserProfileBloc>().emit(
                state.copyWith(hasShownSuccessMessage: true),
              );
            }
          },
          builder: (context, state) {
            if (state.userProfileApi.status == Status.loading) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              );
            }
            return const SizedBox(); // No UI by default
          },
        ),
      ],
    );
  }
}
