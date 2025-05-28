import 'package:do_host/bloc/register_bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart'; // Importing app localizations for translated text

/// A widget representing the password input field.

class ConfirmPasswordInputWidget extends StatefulWidget {
  const ConfirmPasswordInputWidget({super.key});

  @override
  State<ConfirmPasswordInputWidget> createState() =>
      _ConfirmPasswordInputWidgetState();
}

class _ConfirmPasswordInputWidgetState
    extends State<ConfirmPasswordInputWidget> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: confirmPasswordController,
            focusNode: focusNode,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock_outline),
              labelText: 'Confirm Password',
              helperText: 'Re-enter your password to ensure it matches.',
              helperMaxLines: 2,
              errorMaxLines: 2,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _togglePasswordView,
              ),
            ),

            obscureText: _obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter confirm password';
              }
              if (value.length < 6) {
                return 'Please enter a password greater than 6 characters';
              }
              return null;
            },
            onChanged: (value) {
              context.read<RegisterBloc>().add(
                ConfirmPasswordChanged(confirmPassword: value),
              );
            },
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }
}
