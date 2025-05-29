import 'package:do_host/configs/color/color.dart';
import 'package:do_host/view/post/job_post/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/post_job_bloc/post_job_bloc.dart';
import '../../../dependency_injection/locator.dart';

class JobPostWidget extends StatefulWidget {
  final String? userId;
  const JobPostWidget({super.key, required this.userId});

  @override
  State<JobPostWidget> createState() => _JobPostWidgetState();
}

class _JobPostWidgetState extends State<JobPostWidget> {
  late PostJobBloc _postJobBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _postJobBloc = PostJobBloc(postJobApiRepository: getIt());

    // Use named parameter for userId safely
    if (widget.userId != null) {
      _postJobBloc.add(UserIdChanged(userId: widget.userId!));
    }
  }

  @override
  void dispose() {
    _postJobBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Your Job',
          style: TextStyle(color: Colors.white), // white title text
        ),
        backgroundColor: AppColors.buttonColor, // deep orange background
        iconTheme: const IconThemeData(color: Colors.white), // back icon color
      ),
      body: BlocProvider(
        create: (_) => _postJobBloc,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double contentWidth = constraints.maxWidth;
              double maxContentWidth;

              if (contentWidth < 600) {
                maxContentWidth = contentWidth; // Mobile
              } else if (contentWidth < 1100) {
                maxContentWidth = 600; // Tablet/Web Small
              } else {
                maxContentWidth = 800; // Desktop/Web Large
              }

              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: maxContentWidth,
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          const JobTitleWidget(),
                          const SizedBox(height: 10),
                          const CompanyNameWidget(),
                          const SizedBox(height: 10),
                          const JobLocationWidget(),
                          const SizedBox(height: 10),
                          const JobDescriptionWidget(),
                          const SizedBox(height: 10),
                          const ApplyUrlWidget(),
                          const SizedBox(height: 10),
                          const LastDateWidget(),
                          const SizedBox(height: 20),
                          JobSubmitButton(formKey: _formKey),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
