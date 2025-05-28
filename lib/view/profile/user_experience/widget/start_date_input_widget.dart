import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class StartDateInputWidget extends StatefulWidget {
  const StartDateInputWidget({super.key});

  @override
  State<StartDateInputWidget> createState() => _StartDateInputWidgetState();
}

class _StartDateInputWidgetState extends State<StartDateInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _startDateController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _startDateController.dispose();
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
            controller: _startDateController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today_outlined),
              labelText: "Start Date",
              helperText: "Enter the start date of your job",
            ),
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.next,
            onTap: () async {
              // Show date picker with black date text
              final DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.deepOrange, // header background color
                        onPrimary: Colors.white, // header text color
                        onSurface: Colors.black, // body text color (dates)
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Colors.deepOrange, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (selectedDate != null) {
                final formattedDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(selectedDate);
                setState(() {
                  _startDateController.text = formattedDate;
                });
                context.read<UserExperienceBloc>().add(
                  StartDateChanged(startDate: formattedDate),
                );
              }
            },

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a start date';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
