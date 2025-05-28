import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FullNameInputWidget extends StatefulWidget {
  const FullNameInputWidget({super.key});

  @override
  State<FullNameInputWidget> createState() => _FullNameInputWidgetState();
}

class _FullNameInputWidgetState extends State<FullNameInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _fullNameController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.person_outline),
              labelText: "Full Name",
              helperText: "Enter your full name",
            ),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserProfileBloc>().add(
                FullNameChanged(fullName: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
