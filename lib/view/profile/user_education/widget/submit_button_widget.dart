import 'package:do_host/bloc/user_education_bloc/user_education_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_host/configs/components/round_button.dart';
import 'package:do_host/configs/routes/routes_name.dart';
import 'package:do_host/utils/extensions/flush_bar_extension.dart';
import 'package:do_host/data/response/status.dart';

/// A widget representing the submit button for the post content form.
class UserEducationSubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const UserEducationSubmitButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserEducationBloc, UserEducationState>(
      listenWhen: (current, previous) =>
          current.userEducationApi.status != previous.userEducationApi.status,
      listener: (context, state) {
        if (state.userEducationApi.status == Status.error) {
          context.flushBarErrorMessage(
            message: state.userEducationApi.message.toString(),
          );
        }

        if (state.userEducationApi.status == Status.completed) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.myHome,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return RoundButton(
          title: 'Add Education',
          loading: state.userEducationApi.status == Status.loading,
          onPress: () {
            if (formKey.currentState!.validate()) {
              context.read<UserEducationBloc>().add(const UserEducationApi());
            }
          },
        );
      },
    );
  }
}
