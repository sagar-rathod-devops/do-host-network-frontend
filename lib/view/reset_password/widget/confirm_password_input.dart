import 'package:do_host/bloc/reset_password_bloc/reset_password_bloc.dart';
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
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: confirmPasswordController,
            focusNode: focusNode,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock),
              labelText: 'Confirm Password',
              helperText: 'Re-enter your password to confirm.',
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
              if (value == null || value.isEmpty) {
                return 'Please enter confirm password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onChanged: (value) {
              context.read<ResetPasswordBloc>().add(
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
