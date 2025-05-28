import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/view/profile/user_profile/widget/designation_input_widget.dart';
import 'package:do_host/view/profile/user_profile/widget/email_input_widget.dart';
import 'package:do_host/view/profile/user_profile/widget/full_name_input_widget.dart';
import 'package:do_host/view/profile/user_profile/widget/location_input_widget.dart';
import 'package:do_host/view/profile/user_profile/widget/number_input_widget.dart';
import 'package:do_host/view/profile/user_profile/widget/organization_input_widget.dart';
import 'package:do_host/view/profile/user_profile/widget/profile_image_input_widget.dart';
import 'package:do_host/view/profile/user_profile/widget/submit_button_widget.dart';
import 'package:do_host/view/profile/user_profile/widget/summary_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection/locator.dart';

class UserProfileWidget extends StatelessWidget {
  final String? userId;

  const UserProfileWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(body: Center(child: Text("Invalid user ID")));
    }

    return BlocProvider(
      create: (_) {
        final bloc = UserProfileBloc(userProfileApiRepository: getIt());
        bloc.add(UserIdChanged(userId: userId!));
        return bloc;
      },
      child: const _UserProfileForm(),
    );
  }
}

class _UserProfileForm extends StatefulWidget {
  const _UserProfileForm();

  @override
  State<_UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<_UserProfileForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Your Profile',
          style: TextStyle(color: Colors.white), // white title text
        ),
        backgroundColor: AppColors.buttonColor, // deep orange background
        iconTheme: const IconThemeData(color: Colors.white), // back icon color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 15),
                    UploadImageWidget(),
                    const SizedBox(height: 10),
                    FullNameInputWidget(),
                    const SizedBox(height: 10),
                    DesignationInputWidget(),
                    const SizedBox(height: 10),
                    EmailInputWidget(),
                    const SizedBox(height: 10),
                    ContactNumberInputWidget(),
                    const SizedBox(height: 10),
                    ProfessionalSummaryInputWidget(),
                    const SizedBox(height: 10),
                    LocationInputWidget(),
                    const SizedBox(height: 10),
                    OrganizationInputWidget(),
                    const SizedBox(height: 15),
                    UserProfileSubmitButton(formKey: _formKey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
