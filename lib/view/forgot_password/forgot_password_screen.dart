import 'package:do_host/bloc/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:do_host/view/forgot_password/widget/app_icon.dart';
import 'package:do_host/view/forgot_password/widget/text_widget.dart';
import 'package:do_host/view/forgot_password/widget/email_input_widget.dart';
import 'package:do_host/view/forgot_password/widget/submit_button_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection/locator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPasswordBloc _registerBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registerBloc = ForgotPasswordBloc(forgotPasswordApiRepository: getIt());
  }

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _registerBloc,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 35),
                      const AppIcon(),
                      const WelcomeText(),
                      const SizedBox(height: 20),
                      const EmailInputWidget(), // Widget for email input field
                      const SizedBox(
                        height: 20,
                      ), // Space between fields and submit button
                      SubmitButton(
                        formKey: _formKey,
                      ), // Widget for submit button
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
