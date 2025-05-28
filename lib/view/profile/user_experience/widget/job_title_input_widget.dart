import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobTitleInputWidget extends StatefulWidget {
  const JobTitleInputWidget({super.key});

  @override
  State<JobTitleInputWidget> createState() => _JobTitleInputWidgetState();
}

class _JobTitleInputWidgetState extends State<JobTitleInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _jobTitleController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserExperienceBloc, UserExperienceState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _jobTitleController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.work_outline),
              labelText: "Job Title",
              helperText:
                  "Enter your job title (e.g., Software Engineer, Product Manager)",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserExperienceBloc>().add(
                JobTitleChanged(jobTitle: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your job title';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
