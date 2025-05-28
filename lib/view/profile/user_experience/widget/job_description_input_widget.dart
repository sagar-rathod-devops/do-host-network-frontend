import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobDescriptionInputWidget extends StatefulWidget {
  const JobDescriptionInputWidget({super.key});

  @override
  State<JobDescriptionInputWidget> createState() =>
      _JobDescriptionInputWidgetState();
}

class _JobDescriptionInputWidgetState extends State<JobDescriptionInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _jobDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _jobDescriptionController.dispose();
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
            controller: _jobDescriptionController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.description_outlined),
              labelText: "Job Description",
              helperText:
                  "Enter a brief description of your job responsibilities",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserExperienceBloc>().add(
                JobDescriptionChanged(jobDescription: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the job description';
              }
              return null;
            },
            maxLines: 4, // Allows for multi-line input
          ),
        );
      },
    );
  }
}
