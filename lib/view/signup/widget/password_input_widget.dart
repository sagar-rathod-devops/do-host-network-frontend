import 'package:do_host/bloc/register_bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart'; // Importing app localizations for translated text

/// A widget representing the password input field.

class PasswordInputWidget extends StatefulWidget {
  const PasswordInputWidget({super.key});

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNode.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350, // Set your desired width
          child: TextFormField(
            controller: passwordController,
            focusNode: focusNode, // Setting focus node
            decoration: InputDecoration(
              icon: const Icon(Icons.lock), // Icon for password input field
              helperText: AppLocalizations.of(
                context,
              )!.passwordShouldbeatleast_characterswithatleastoneletterandnumber, // Helper text for password input field
              helperMaxLines: 2, // Maximum lines for helper text
              labelText: AppLocalizations.of(
                context,
              )!.password, // Label text for password input field
              errorMaxLines: 2, // Maximum lines for error text
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _togglePasswordView,
              ),
            ),
            obscureText:
                _obscureText, // Making the text input obscure (i.e., showing dots instead of actual characters)
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter password';
              }
              if (value.length < 6) {
                return 'Please enter a password greater than 6 characters';
              }
              return null;
            },
            onChanged: (value) {
              // Dispatching PasswordChanged event when password input changes
              context.read<RegisterBloc>().add(
                PasswordChanged(password: value),
              );
            },
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }
}
