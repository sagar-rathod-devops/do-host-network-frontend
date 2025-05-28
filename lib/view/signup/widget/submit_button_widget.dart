import 'package:do_host/bloc/register_bloc/register_bloc.dart';
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
    return BlocConsumer<RegisterBloc, RegisterState>(
      listenWhen: (current, previous) =>
          current.signupApi.status != previous.signupApi.status,
      listener: (context, state) {
        if (state.signupApi.status == Status.error) {
          context.flushBarErrorMessage(
            message: state.signupApi.message.toString(),
          );
        }

        if (state.signupApi.status == Status.completed) {
          print("Navigating to VerifyOTP with email: ${state.email}");
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.verifyOTP,
            arguments: state.email,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return RoundButton(
          title: 'Sign up',
          loading: state.signupApi.status == Status.loading ? true : false,
          onPress: () {
            if (formKey.currentState.validate()) {
              context.read<RegisterBloc>().add(const SignupApi());
            }
          },
        );
      },
    );
  }
}
