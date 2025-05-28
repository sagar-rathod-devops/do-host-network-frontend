import 'package:do_host/bloc/user_experience_bloc/user_experience_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/view/profile/user_experience/widget/achievements_input_widget.dart';
import 'package:do_host/view/profile/user_experience/widget/company_name_input_widget.dart';
import 'package:do_host/view/profile/user_experience/widget/end_date_input_widget.dart';
import 'package:do_host/view/profile/user_experience/widget/job_description_input_widget.dart';
import 'package:do_host/view/profile/user_experience/widget/job_title_input_widget.dart';
import 'package:do_host/view/profile/user_experience/widget/location_input_widget.dart';
import 'package:do_host/view/profile/user_experience/widget/start_date_input_widget.dart';
import 'package:do_host/view/profile/user_experience/widget/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection/locator.dart';

class UserExperienceWidget extends StatefulWidget {
  final String? userId;
  const UserExperienceWidget({super.key, required this.userId});

  @override
  State<UserExperienceWidget> createState() => _UserExperienceWidgetState();
}

class _UserExperienceWidgetState extends State<UserExperienceWidget> {
  late UserExperienceBloc _userExperienceBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userExperienceBloc = UserExperienceBloc(
      userExperienceApiRepository: getIt(),
    );

    // Corrected: Use named parameter for userId
    _userExperienceBloc.add(UserIdChanged(userId: widget.userId!));
  }

  @override
  void dispose() {
    _userExperienceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Experience Details',
          style: TextStyle(color: Colors.white), // white title text
        ),
        backgroundColor: AppColors.buttonColor, // deep orange background
        iconTheme: const IconThemeData(color: Colors.white), // back icon color
      ),

      body: BlocProvider(
        create: (_) => _userExperienceBloc,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 5),
                      const JobTitleInputWidget(),
                      const SizedBox(height: 10),
                      const CompanyNameInputWidget(),
                      const SizedBox(height: 10),
                      const JobDescriptionInputWidget(),
                      const SizedBox(height: 10),
                      const AchievementsInputWidget(),
                      const SizedBox(height: 10),
                      const LocationInputWidget(),
                      const SizedBox(height: 10),
                      const StartDateInputWidget(),
                      const SizedBox(height: 10),
                      const EndDateInputWidget(),
                      const SizedBox(height: 15),
                      UserExperienceSubmitButton(formKey: _formKey),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
