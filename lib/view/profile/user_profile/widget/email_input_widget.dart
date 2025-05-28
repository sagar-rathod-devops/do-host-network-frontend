import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:do_host/utils/extensions/validations_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailInputWidget extends StatefulWidget {
  const EmailInputWidget({super.key});

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _emailController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.email_outlined),
              labelText: "Email",
              helperText: "Enter a valid email address",
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserProfileBloc>().add(EmailChanged(email: value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!value.emailValidator()) {
                return 'Email is not correct';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
