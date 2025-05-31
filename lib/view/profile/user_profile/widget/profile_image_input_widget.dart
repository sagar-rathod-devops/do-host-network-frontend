import 'dart:typed_data';

import 'package:do_host/data/response/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io; // For desktop/mobile only
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../../bloc/user_profile_bloc/user_profile_bloc.dart';

class UploadImageWidget extends StatefulWidget {
  const UploadImageWidget({Key? key}) : super(key: key);

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  io.File? _selectedImageFile; // For desktop/mobile
  Uint8List? _selectedImageBytes; // For web
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = null;
        });
        // Dispatch event with bytes for web
        context.read<UserProfileBloc>().add(
          ProfileImageChangedWeb(
            imageBytes: bytes,
          ), // Define this event for web
        );
      } else {
        final file = io.File(pickedFile.path);
        setState(() {
          _selectedImageFile = file;
          _selectedImageBytes = null;
        });
        // Dispatch event with File for desktop/mobile
        context.read<UserProfileBloc>().add(
          ProfileImageChanged(profileImage: file),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (kIsWeb && _selectedImageBytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: Image.memory(
              _selectedImageBytes!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          )
        else if (_selectedImageFile != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: Image.file(
              _selectedImageFile!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton.icon(
          icon: const Icon(Icons.upload),
          label: const Text("Choose Image"),
          onPressed: () => _pickImage(context),
        ),

        // ElevatedButton.icon(
        //   icon: const Icon(Icons.upload),
        //   label: const Text("Choose Image"),
        //   onPressed: () => _pickImage(context),
        // ),
        BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state.userProfileApi.status == Status.completed &&
                !state.hasShownSuccessMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Image uploaded successfully!')),
              );

              // Set flag true so it doesn’t show again
              context.read<UserProfileBloc>().add(
                HasShownSuccessMessageChanged(hasShown: true),
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
