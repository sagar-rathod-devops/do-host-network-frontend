import 'package:do_host/bloc/register_bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart'; // Importing app localizations for translated text

/// A widget representing the password input field.

class UsernameInputWidget extends StatefulWidget {
  const UsernameInputWidget({super.key});

  @override
  State<UsernameInputWidget> createState() => _UsernameInputWidgetState();
}

class _UsernameInputWidgetState extends State<UsernameInputWidget> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNode.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350, // Set your desired width
          child: TextFormField(
            controller: usernameController,
            focusNode: focusNode, // Setting focus node
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              labelText: 'Create a Username',
              helperText:
                  'This will be your unique identity. Use 3–20 letters or numbers — no spaces.',
              helperMaxLines: 2,
              errorMaxLines: 2,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter username';
              }
              return null;
            },
            onChanged: (value) {
              // Dispatching PasswordChanged event when password input changes
              context.read<RegisterBloc>().add(
                UserNameChanged(username: value),
              );
            },
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }
}
