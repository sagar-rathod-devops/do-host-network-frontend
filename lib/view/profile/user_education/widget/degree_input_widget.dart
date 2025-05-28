import 'package:do_host/bloc/user_education_bloc/user_education_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DegreeInputWidget extends StatefulWidget {
  const DegreeInputWidget({super.key});

  @override
  State<DegreeInputWidget> createState() => _DegreeInputWidgetState();
}

class _DegreeInputWidgetState extends State<DegreeInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _degreeController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _degreeController.dispose();
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
            controller: _degreeController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.school_outlined),
              labelText: "Degree",
              helperText: "Enter your degree (e.g., B.Tech, M.Sc, etc.)",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserEducationBloc>().add(
                DegreeChanged(degree: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your degree';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
