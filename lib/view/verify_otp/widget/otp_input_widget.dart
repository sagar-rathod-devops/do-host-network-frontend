import 'package:do_host/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart'; // Importing app localizations for translated text

/// A widget representing the password input field.

class VerifyOTPInputWidget extends StatefulWidget {
  const VerifyOTPInputWidget({super.key});

  @override
  State<VerifyOTPInputWidget> createState() => _VerifyOTPInputWidgetState();
}

class _VerifyOTPInputWidgetState extends State<VerifyOTPInputWidget> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController verifyOTPController = TextEditingController();

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
    verifyOTPController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350, // Set your desired width
          child: TextFormField(
            controller: verifyOTPController,
            focusNode: focusNode, // Setting focus node
            decoration: InputDecoration(
              icon: const Icon(Icons.verified, color: Colors.blue),
              // Icon for OTP input
              labelText: 'Verification Code', // Label for the input field
              helperText: 'Enter the 6-digit OTP sent to your email or phone.',
              helperMaxLines: 2,
              errorMaxLines: 2,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _togglePasswordView,
              ), // Optional: You can use another relevant icon
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
              context.read<VerifyOtpBloc>().add(OTPChanged(otp: value));
            },
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }
}
