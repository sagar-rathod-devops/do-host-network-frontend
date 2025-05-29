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
          child: LayoutBuilder(
            builder: (context, constraints) {
              double contentWidth = constraints.maxWidth;
              double maxContentWidth = contentWidth < 600
                  ? contentWidth // Mobile
                  : contentWidth < 1100
                  ? 600 // Tablet/Web Small
                  : 800; // Desktop/Web Large

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
                          const UsernameInputWidget(),
                          const EmailInputWidget(),
                          const PasswordInputWidget(),
                          const ConfirmPasswordInputWidget(),
                          const SizedBox(height: 20),
                          SubmitButton(formKey: _formKey),
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
