import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_host/bloc/post_content_bloc/post_content_bloc.dart';
import 'package:do_host/configs/components/round_button.dart';
import 'package:do_host/configs/routes/routes_name.dart';
import 'package:do_host/utils/extensions/flush_bar_extension.dart';
import 'package:do_host/data/response/status.dart';

/// A widget representing the submit button for the post content form.
class PostSubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const PostSubmitButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostContentBloc, PostContentState>(
      listenWhen: (current, previous) =>
          current.postApiResponse.status != previous.postApiResponse.status,
      listener: (context, state) {
        if (state.postApiResponse.status == Status.error) {
          context.flushBarErrorMessage(
            message: state.postApiResponse.message.toString(),
          );
        }

        if (state.postApiResponse.status == Status.completed) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.myHome,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return RoundButton(
          title: 'Post',
          loading: state.postApiResponse.status == Status.loading,
          onPress: () {
            if (formKey.currentState!.validate()) {
              context.read<PostContentBloc>().add(const SubmitPostApi());
            }
          },
        );
      },
    );
  }
}
