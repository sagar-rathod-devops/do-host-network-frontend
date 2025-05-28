import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Add intl package to format the date

class EndDateInputWidget extends StatefulWidget {
  const EndDateInputWidget({super.key});

  @override
  State<EndDateInputWidget> createState() => _EndDateInputWidgetState();
}

class _EndDateInputWidgetState extends State<EndDateInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _endDateController.dispose();
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
            controller: _endDateController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today_outlined),
              labelText: "End Date",
              helperText: "Enter the end date of your job (if applicable)",
            ),
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.done,
            onTap: () async {
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
                        onSurface: Colors.black, // date text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Colors.deepOrange, // confirm/cancel button color
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
                  _endDateController.text = formattedDate;
                });
                context.read<UserExperienceBloc>().add(
                  EndDateChanged(endDate: formattedDate),
                );
              }
            },

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter an end date (or leave blank if ongoing)';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
