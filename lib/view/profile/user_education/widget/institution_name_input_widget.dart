import 'package:do_host/bloc/user_education_bloc/user_education_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstitutionNameInputWidget extends StatefulWidget {
  const InstitutionNameInputWidget({super.key});

  @override
  State<InstitutionNameInputWidget> createState() =>
      _InstitutionNameInputWidgetState();
}

class _InstitutionNameInputWidgetState
    extends State<InstitutionNameInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _institutionNameController =
      TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _institutionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserEducationBloc, UserEducationState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _institutionNameController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.school_outlined),
              labelText: "Institution Name",
              helperText: "Enter the name of your institution",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserEducationBloc>().add(
                InstitutionNameChanged(institutionName: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the institution name';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
