import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_host/configs/components/round_button.dart';
import 'package:do_host/configs/routes/routes_name.dart';
import 'package:do_host/utils/extensions/flush_bar_extension.dart';
import 'package:do_host/data/response/status.dart';

import '../../../../bloc/post_job_bloc/post_job_bloc.dart';

/// A widget representing the submit button for the post content form.
class JobSubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const JobSubmitButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostJobBloc, PostJobState>(
      listenWhen: (current, previous) =>
          current.postJobApi.status != previous.postJobApi.status,
      listener: (context, state) {
        if (state.postJobApi.status == Status.error) {
          context.flushBarErrorMessage(
            message: state.postJobApi.message.toString(),
          );
        }

        if (state.postJobApi.status == Status.completed) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.myHome,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return RoundButton(
          title: 'Post Job',
          loading: state.postJobApi.status == Status.loading,
          onPress: () {
            if (formKey.currentState!.validate()) {
              context.read<PostJobBloc>().add(const PostJobApi());
            }
          },
        );
      },
    );
  }
}
