import 'package:do_host/bloc/user_education_bloc/user_education_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/view/profile/user_education/widget/degree_input_widget.dart';
import 'package:do_host/view/profile/user_education/widget/field_of_study_input_widget.dart';
import 'package:do_host/view/profile/user_education/widget/grade_input_widget.dart';
import 'package:do_host/view/profile/user_education/widget/institution_name_input_widget.dart';
import 'package:do_host/view/profile/user_education/widget/submit_button_widget.dart';
import 'package:do_host/view/profile/user_education/widget/year_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection/locator.dart';

class UserEducationWidget extends StatefulWidget {
  final String? userId;
  const UserEducationWidget({super.key, required this.userId});

  @override
  State<UserEducationWidget> createState() => _UserEducationWidgetState();
}

class _UserEducationWidgetState extends State<UserEducationWidget> {
  late UserEducationBloc _userEducationBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userEducationBloc = UserEducationBloc(userEducationApiRepository: getIt());

    // Corrected: Use named parameter for userId
    _userEducationBloc.add(UserIdChanged(userId: widget.userId!));
  }

  @override
  void dispose() {
    _userEducationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Education Details',
          style: TextStyle(color: Colors.white), // white title text
        ),
        backgroundColor: AppColors.buttonColor, // deep orange background
        iconTheme: const IconThemeData(color: Colors.white), // back icon color
      ),
      body: BlocProvider(
        create: (_) => _userEducationBloc,
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
                      const SizedBox(height: 20),
                      DegreeInputWidget(),
                      const SizedBox(height: 10),
                      FieldOfStudyInputWidget(),
                      const SizedBox(height: 10),
                      InstitutionNameInputWidget(),
                      const SizedBox(height: 10),
                      GradeInputWidget(),
                      const SizedBox(height: 10),
                      YearOfPassingInputWidget(),
                      const SizedBox(height: 20),
                      UserEducationSubmitButton(formKey: _formKey),
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
