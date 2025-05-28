import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_host/configs/components/round_button.dart';
import 'package:do_host/configs/routes/routes_name.dart';
import 'package:do_host/utils/extensions/flush_bar_extension.dart';
import 'package:do_host/data/response/status.dart';

/// A widget representing the update submit button for the user profile form.
class UserProfileUpdateSubmitWidgetButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const UserProfileUpdateSubmitWidgetButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      listenWhen: (previous, current) =>
          previous.userUpdateProfileApi.status !=
          current.userUpdateProfileApi.status,
      listener: (context, state) {
        final status = state.userUpdateProfileApi.status;
        final message = state.userUpdateProfileApi.message;

        if (status == Status.error && message != null && message.isNotEmpty) {
          context.flushBarErrorMessage(message: message);
        }

        if (status == Status.completed) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.myHome,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.userUpdateProfileApi.status == Status.loading;

        return RoundButton(
          title: 'Update Profile',
          loading: isLoading,
          onPress: () {
            if (formKey.currentState?.validate() ?? false) {
              context.read<UserProfileBloc>().add(SubmitUserUpdateProfile());
            }
          },
        );
      },
    );
  }
}
