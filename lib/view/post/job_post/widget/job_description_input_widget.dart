import 'package:do_host/bloc/post_job_bloc/post_job_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobDescriptionWidget extends StatefulWidget {
  const JobDescriptionWidget({super.key});

  @override
  State<JobDescriptionWidget> createState() => _JobDescriptionWidgetState();
}

class _JobDescriptionWidgetState extends State<JobDescriptionWidget> {
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
    return BlocBuilder<PostJobBloc, PostJobState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _jobDescriptionController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              labelText: "Job Description",
              helperText: "Enter a detailed job description",
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 5,
            onChanged: (value) {
              context.read<PostJobBloc>().add(
                JobDescriptionChanged(jobDescription: value),
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a job description';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
