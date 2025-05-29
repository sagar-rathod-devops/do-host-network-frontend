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
                          const SizedBox(height: 20),
                          SubmitButton(formKey: _formKey),
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
