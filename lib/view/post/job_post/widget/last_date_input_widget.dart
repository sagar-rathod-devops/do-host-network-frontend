import 'package:do_host/bloc/post_job_bloc/post_job_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LastDateWidget extends StatefulWidget {
  const LastDateWidget({super.key});

  @override
  State<LastDateWidget> createState() => _LastDateWidgetState();
}

class _LastDateWidgetState extends State<LastDateWidget> {
  final TextEditingController _lastDateController = TextEditingController();

  @override
  void dispose() {
    _lastDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.buttonColor, // header background color
              onPrimary: AppColors.whiteColor, // header text color
              onSurface: AppColors.blackColor, // body text color (dates)
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.buttonColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      _lastDateController.text = formattedDate;
      context.read<PostJobBloc>().add(
        LastDateToApplyChanged(lastDateToApply: formattedDate),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostJobBloc, PostJobState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _lastDateController,
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.date_range),
              labelText: "Last Date to Apply",
              helperText: "Select the last date for job applications",
            ),
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select the last date to apply';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
