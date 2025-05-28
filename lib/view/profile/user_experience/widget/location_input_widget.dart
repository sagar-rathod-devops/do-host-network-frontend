import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationInputWidget extends StatefulWidget {
  const LocationInputWidget({super.key});

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
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
    return BlocBuilder<UserExperienceBloc, UserExperienceState>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return SizedBox(
          width: 350,
          child: TextFormField(
            controller: _locationController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.location_on_outlined),
              labelText: "Location",
              helperText:
                  "Enter your job location (e.g., New York, San Francisco)",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserExperienceBloc>().add(
                LocationChanged(location: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your location';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
