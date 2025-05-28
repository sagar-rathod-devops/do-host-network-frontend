import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfessionalSummaryInputWidget extends StatefulWidget {
  const ProfessionalSummaryInputWidget({super.key});

  @override
  State<ProfessionalSummaryInputWidget> createState() =>
      _ProfessionalSummaryInputWidgetState();
}

class _ProfessionalSummaryInputWidgetState
    extends State<ProfessionalSummaryInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _professionalSummaryController =
      TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _professionalSummaryController.dispose();
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
            controller: _professionalSummaryController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.work_outline),
              labelText: "Professional Summary",
              helperText: "Enter a brief professional summary",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserProfileBloc>().add(
                ProfessionalSummaryChanged(professionalSummary: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your professional summary';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
