import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizationInputWidget extends StatefulWidget {
  const OrganizationInputWidget({super.key});

  @override
  State<OrganizationInputWidget> createState() =>
      _OrganizationInputWidgetState();
}

class _OrganizationInputWidgetState extends State<OrganizationInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _organizationController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _organizationController.dispose();
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
            controller: _organizationController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.business_outlined),
              labelText: "Organization",
              helperText: "Enter the name of your organization",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserProfileBloc>().add(
                OrganizationChanged(organization: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your organization name';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
