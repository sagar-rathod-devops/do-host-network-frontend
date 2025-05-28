import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_host/configs/components/round_button.dart';
import 'package:do_host/configs/routes/routes_name.dart';
import 'package:do_host/utils/extensions/flush_bar_extension.dart';
import 'package:do_host/data/response/status.dart';

/// A widget representing the submit button for the post content form.
class UserExperienceSubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const UserExperienceSubmitButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserExperienceBloc, UserExperienceState>(
      listenWhen: (current, previous) =>
          current.userExperienceApi.status != previous.userExperienceApi.status,
      listener: (context, state) {
        if (state.userExperienceApi.status == Status.error) {
          context.flushBarErrorMessage(
            message: state.userExperienceApi.message.toString(),
          );
        }

        if (state.userExperienceApi.status == Status.completed) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.myHome,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return RoundButton(
          title: 'Add Experience',
          loading: state.userExperienceApi.status == Status.loading,
          onPress: () {
            if (formKey.currentState!.validate()) {
              context.read<UserExperienceBloc>().add(const UserExperienceApi());
            }
          },
        );
      },
    );
  }
}
