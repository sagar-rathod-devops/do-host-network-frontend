import 'package:do_host/bloc/register_bloc/register_bloc.dart';
import 'package:do_host/view/signup/widget/username_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widget/widgets.dart';
import '../../dependency_injection/locator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late RegisterBloc _registerBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registerBloc = RegisterBloc(registerApiRepository: getIt());
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
                      const UsernameInputWidget(),
                      const EmailInputWidget(), // Widget for email input field
                      const PasswordInputWidget(), // Widget for password input field
                      const ConfirmPasswordInputWidget(),
                      const SizedBox(
                        height: 20,
                      ), // Space between fields and submit button
                      SubmitButton(
                        formKey: _formKey,
                      ), // Widget for submit button
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
