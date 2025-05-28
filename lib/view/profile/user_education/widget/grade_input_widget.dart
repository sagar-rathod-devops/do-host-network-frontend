import 'package:do_host/bloc/user_education_bloc/user_education_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradeInputWidget extends StatefulWidget {
  const GradeInputWidget({super.key});

  @override
  State<GradeInputWidget> createState() => _GradeInputWidgetState();
}

class _GradeInputWidgetState extends State<GradeInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _gradeController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _gradeController.dispose();
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
            controller: _gradeController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.grade_outlined),
              labelText: "Grade",
              helperText: "Enter your grade or GPA (e.g., 3.5, A)",
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserEducationBloc>().add(GradeChanged(grade: value));
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your grade';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
