import 'package:do_host/bloc/post_job_bloc/post_job_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobTitleWidget extends StatefulWidget {
  const JobTitleWidget({super.key});

  @override
  State<JobTitleWidget> createState() => _JobTitleWidgetState();
}

class _JobTitleWidgetState extends State<JobTitleWidget> {
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
    return BlocBuilder<PostJobBloc, PostJobState>(
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
              helperText: "Enter the title for the job position",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<PostJobBloc>().add(JobTitleChanged(jobTitle: value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a job title';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
