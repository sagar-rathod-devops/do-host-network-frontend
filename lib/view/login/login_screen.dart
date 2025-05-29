import 'package:do_host/view/login/widget/forgot_password_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/login_bloc/login_bloc.dart';
import '../../dependency_injection/locator.dart';
import 'widget/signup_redirect_text_button.dart';
import 'widget/widgets.dart'; // Custom login widgets

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              double contentWidth = constraints.maxWidth;
              double maxContentWidth;

              if (contentWidth < 600) {
                maxContentWidth = contentWidth; // Mobile
              } else if (contentWidth < 1100) {
                maxContentWidth = 600; // Tablet/Web Small
              } else {
                maxContentWidth = 800; // Desktop/Web Large
              }

              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: maxContentWidth,
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 35),
                          const AppIcon(),
                          const WelcomeText(),
                          const SizedBox(height: 20),
                          const EmailInputWidget(),
                          const PasswordInputWidget(),
                          const SizedBox(height: 20),
                          SubmitButton(formKey: _formKey),
                          const ForgotPasswordButton(),
                          const SignupRedirectText(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
