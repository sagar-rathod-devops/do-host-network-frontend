import 'package:do_host/bloc/post_job_bloc/post_job_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobLocationWidget extends StatefulWidget {
  const JobLocationWidget({super.key});

  @override
  State<JobLocationWidget> createState() => _JobLocationWidgetState();
}

class _JobLocationWidgetState extends State<JobLocationWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _locationController.dispose();
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
            controller: _locationController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.location_on),
              labelText: "Job Location",
              helperText: "Enter the location of the job",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<PostJobBloc>().add(LocationChanged(location: value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a job location';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
