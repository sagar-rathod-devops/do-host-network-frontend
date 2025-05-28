import 'package:do_host/bloc/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:do_host/configs/components/round_button.dart';
import 'package:do_host/utils/extensions/flush_bar_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/routes/routes_name.dart';
import '../../../data/response/status.dart';

/// A widget representing the submit button for the OTP verification form.
class SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SubmitButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
      listenWhen: (previous, current) =>
          previous.verifyOTPApi.status != current.verifyOTPApi.status,
      listener: (context, state) {
        if (state.verifyOTPApi.status == Status.error) {
          context.flushBarErrorMessage(
            message: state.verifyOTPApi.message.toString(),
          );
        }

        if (state.verifyOTPApi.status == Status.completed) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.login,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return RoundButton(
          title: 'Verify OTP',
          loading: state.verifyOTPApi.status == Status.loading,
          onPress: () {
            if (formKey.currentState!.validate()) {
              context.read<VerifyOtpBloc>().add(const VerifyOTPApi());
            }
          },
        );
      },
    );
  }
}
