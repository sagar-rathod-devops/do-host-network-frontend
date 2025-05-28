import 'package:do_host/bloc/user_education_bloc/user_education_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldOfStudyInputWidget extends StatefulWidget {
  const FieldOfStudyInputWidget({super.key});

  @override
  State<FieldOfStudyInputWidget> createState() =>
      _FieldOfStudyInputWidgetState();
}

class _FieldOfStudyInputWidgetState extends State<FieldOfStudyInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _fieldOfStudyController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _fieldOfStudyController.dispose();
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
            controller: _fieldOfStudyController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.book_outlined),
              labelText: "Field of Study",
              helperText:
                  "Enter your field of study (e.g., Computer Science, Physics, etc.)",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserEducationBloc>().add(
                FieldOfStudyChanged(fieldOfStudy: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your field of study';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
