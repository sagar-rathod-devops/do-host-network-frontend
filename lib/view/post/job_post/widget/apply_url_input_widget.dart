import 'package:do_host/bloc/post_job_bloc/post_job_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyUrlWidget extends StatefulWidget {
  const ApplyUrlWidget({super.key});

  @override
  State<ApplyUrlWidget> createState() => _ApplyUrlWidgetState();
}

class _ApplyUrlWidgetState extends State<ApplyUrlWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _applyUrlController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _applyUrlController.dispose();
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
            controller: _applyUrlController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.link),
              labelText: "Apply URL",
              helperText:
                  "Enter a valid application URL (e.g., job apply link)",
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<PostJobBloc>().add(
                JobApplyUrlChanged(jobApplyUrl: value),
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an application URL';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
