import 'package:do_host/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:do_host/view/reset_password/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection/locator.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordBloc _resetPasswordBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _resetPasswordBloc = ResetPasswordBloc(resetPasswordApiRepository: getIt());

    // Print to verify if email is received
    print("Received email in VerifyOtpScreen: ${widget.email}");

    // Dispatch email to BLoC after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetPasswordBloc.add(EmailChanged(email: widget.email));
    });
  }

  @override
  void dispose() {
    _resetPasswordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _resetPasswordBloc,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 35),
                      const AppIcon(),
                      const WelcomeText(),
                      const SizedBox(height: 20),
                      const OTPInputWidget(),
                      const PasswordInputWidget(),
                      const ConfirmPasswordInputWidget(),
                      const SizedBox(height: 20),
                      SubmitButton(formKey: _formKey),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
