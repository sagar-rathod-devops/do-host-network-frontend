import 'package:do_host/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:do_host/view/verify_otp/widget/app_icon.dart';
import 'package:do_host/view/verify_otp/widget/text_widget.dart';
import 'package:do_host/view/verify_otp/widget/verify_otp_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection/locator.dart';
import 'widget/otp_input_widget.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late VerifyOtpBloc _verifyOtpBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _verifyOtpBloc = VerifyOtpBloc(verifyOtpApiRepository: getIt());

    // Print to verify if email is received
    print("Received email in VerifyOtpScreen: ${widget.email}");

    // Dispatch email to BLoC after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyOtpBloc.add(EmailChanged(email: widget.email));
    });
  }

  @override
  void dispose() {
    _verifyOtpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _verifyOtpBloc,
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
                      const VerifyOTPInputWidget(),
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
