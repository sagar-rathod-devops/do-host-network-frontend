import 'package:do_host/view/login/widget/forgot_password_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/login_bloc/login_bloc.dart';

import '../../dependency_injection/locator.dart';
import 'widget/signup_redirect_text_button.dart';
import 'widget/widgets.dart'; // Importing custom widget components

/// A widget representing the login screen of the application.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// The state of the [LoginScreen] widget.
class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBlocs;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBlocs = LoginBloc(authApiRepository: getIt());
  }

  @override
  void dispose() {
    _loginBlocs.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _loginBlocs,
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
                      const PasswordInputWidget(), // Widget for password input field
                      const SizedBox(
                        height: 20,
                      ), // Space between fields and submit button
                      SubmitButton(
                        formKey: _formKey,
                      ), // Widget for submit button
                      const ForgotPasswordButton(),
                      const SignupRedirectText(),
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
