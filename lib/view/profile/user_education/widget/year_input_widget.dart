import 'package:do_host/bloc/user_education_bloc/user_education_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YearOfPassingInputWidget extends StatefulWidget {
  const YearOfPassingInputWidget({super.key});

  @override
  State<YearOfPassingInputWidget> createState() =>
      _YearOfPassingInputWidgetState();
}

class _YearOfPassingInputWidgetState extends State<YearOfPassingInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _yearOfPassingController =
      TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _yearOfPassingController.dispose();
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
            controller: _yearOfPassingController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.date_range_outlined),
              labelText: "Year of Passing",
              helperText: "Enter your year of passing (e.g., 2020, 2021)",
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserEducationBloc>().add(YearChanged(year: value));
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your year of passing';
              }
              if (int.tryParse(value) == null || value.length != 4) {
                return 'Please enter a valid year';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
