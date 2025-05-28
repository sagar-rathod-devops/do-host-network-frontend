import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactNumberInputWidget extends StatefulWidget {
  const ContactNumberInputWidget({super.key});

  @override
  State<ContactNumberInputWidget> createState() =>
      _ContactNumberInputWidgetState();
}

class _ContactNumberInputWidgetState extends State<ContactNumberInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _contactNumberController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactNumber = context.read<UserProfileBloc>().state.contactNumber;
      if (contactNumber.isNotEmpty) {
        _contactNumberController.text = contactNumber;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      buildWhen: (previous, current) =>
          previous.contactNumber != current.contactNumber,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _contactNumberController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone_outlined),
              labelText: "Contact Number",
              helperText: "Enter your contact number",
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserProfileBloc>().add(
                ContactNumberChanged(contactNumber: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your contact number';
              } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
