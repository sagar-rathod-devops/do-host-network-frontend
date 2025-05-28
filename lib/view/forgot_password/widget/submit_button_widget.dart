import 'package:do_host/bloc/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:do_host/configs/components/round_button.dart';
import 'package:do_host/utils/extensions/flush_bar_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/routes/routes_name.dart';
import '../../../data/response/status.dart';

/// A widget representing the submit button for the login form.
class SubmitButton extends StatelessWidget {
  final formKey;
  const SubmitButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (current, previous) =>
          current.forgotPasswordApi.status != previous.forgotPasswordApi.status,
      listener: (context, state) {
        if (state.forgotPasswordApi.status == Status.error) {
          context.flushBarErrorMessage(
            message: state.forgotPasswordApi.message.toString(),
          );
        }

        if (state.forgotPasswordApi.status == Status.completed) {
          print("Navigating to VerifyOTP with email: ${state.email}");
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.resetPassword,
            arguments: state.email,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return RoundButton(
          title: 'Forgot Password',
          loading: state.forgotPasswordApi.status == Status.loading
              ? true
              : false,
          onPress: () {
            if (formKey.currentState.validate()) {
              context.read<ForgotPasswordBloc>().add(const ForgotPasswordApi());
            }
          },
        );
      },
    );
  }
}
