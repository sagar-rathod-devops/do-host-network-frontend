import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyNameInputWidget extends StatefulWidget {
  const CompanyNameInputWidget({super.key});

  @override
  State<CompanyNameInputWidget> createState() => _CompanyNameInputWidgetState();
}

class _CompanyNameInputWidgetState extends State<CompanyNameInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _companyNameController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _companyNameController.dispose();
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
            controller: _companyNameController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.business_outlined),
              labelText: "Company Name",
              helperText: "Enter the name of your company",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserExperienceBloc>().add(
                CompanyNameChanged(companyName: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the company name';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
