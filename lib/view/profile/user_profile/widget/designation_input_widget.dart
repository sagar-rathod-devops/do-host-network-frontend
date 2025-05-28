import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesignationInputWidget extends StatefulWidget {
  const DesignationInputWidget({super.key});

  @override
  State<DesignationInputWidget> createState() => _DesignationInputWidgetState();
}

class _DesignationInputWidgetState extends State<DesignationInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _designationController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _designationController.dispose();
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
            controller: _designationController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.work_outline),
              labelText: "Designation",
              helperText: "Enter your current job title or role",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserProfileBloc>().add(
                DesignationChanged(designation: value),
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your designation';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
