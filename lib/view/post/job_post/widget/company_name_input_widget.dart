import 'package:do_host/bloc/post_job_bloc/post_job_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyNameWidget extends StatefulWidget {
  const CompanyNameWidget({super.key});

  @override
  State<CompanyNameWidget> createState() => _CompanyNameWidgetState();
}

class _CompanyNameWidgetState extends State<CompanyNameWidget> {
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
    return BlocBuilder<PostJobBloc, PostJobState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _companyNameController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.business),
              labelText: "Company Name",
              helperText: "Enter the name of the hiring company",
            ),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<PostJobBloc>().add(
                CompanyNameChanged(companyName: value),
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
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
