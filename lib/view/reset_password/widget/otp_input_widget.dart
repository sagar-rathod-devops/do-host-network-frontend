import 'package:do_host/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart'; // Importing app localizations for translated text

/// A widget representing the password input field.

class OTPInputWidget extends StatefulWidget {
  const OTPInputWidget({super.key});

  @override
  State<OTPInputWidget> createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController otpController = TextEditingController();

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
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350, // Set your desired width
          child: TextFormField(
            controller: otpController,
            focusNode: focusNode, // Setting focus node
            keyboardType: TextInputType.number, // Numeric keyboard
            decoration: InputDecoration(
              icon: const Icon(
                Icons.verified,
                color: Colors.blue,
              ), // OTP icon with blue color
              labelText: 'Enter OTP', // Label for the field
              helperText:
                  'Enter the 6-digit code sent to your email to verify your identity.', // Helper instructions
              helperMaxLines: 2, // Max lines for helper text
              errorMaxLines: 2, // Max lines for error messages
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
                return 'Enter Correct OTP';
              }
              // if (value.length < 6) {
              //   return 'Please enter a correct otp';
              // }
              return null;
            },
            onChanged: (value) {
              // Dispatching PasswordChanged event when password input changes
              context.read<ResetPasswordBloc>().add(OTPChanged(otp: value));
            },
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }
}
