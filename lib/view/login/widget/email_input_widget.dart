import 'package:do_host/utils/extensions/validations_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart'; // Importing app localizations for translated text

import '../../../bloc/login_bloc/login_bloc.dart';

/// A widget representing the email input field.

class EmailInputWidget extends StatefulWidget {
  const EmailInputWidget({super.key});

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginStates>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350, // Set your desired width
          child: TextFormField(
            controller: emailController,
            focusNode: focusNode, // Setting focus node
            decoration: InputDecoration(
              icon: const Icon(Icons.email), // Icon for email input field
              labelText:
                  'Email or Username', // Label text for email input field
              helperText:
                  'A complete, valid email e.g. joe@gmail.com or username', // Helper text for email input field
            ),
            keyboardType: TextInputType
                .emailAddress, // Setting keyboard type to email address
            onChanged: (value) {
              // Dispatching EmailChanged event when email input changes
              context.read<LoginBloc>().add(EmailChanged(email: value));
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter email or username';
              }
              // if (!value.emailValidator()) {
              //   return 'Email is not correct';
              // }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
        );
      },
    );
  }
}
