import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsInputWidget extends StatefulWidget {
  const AchievementsInputWidget({super.key});

  @override
  State<AchievementsInputWidget> createState() =>
      _AchievementsInputWidgetState();
}

class _AchievementsInputWidgetState extends State<AchievementsInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _achievementsController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _achievementsController.dispose();
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
            controller: _achievementsController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              icon: Icon(Icons.emoji_events_outlined),
              labelText: "Achievements",
              helperText: "Enter your achievements or awards",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<UserExperienceBloc>().add(
                AchievementsChanged(achievements: value),
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your achievements';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
