import 'package:do_host/configs/color/color.dart';
import 'package:do_host/view/post/content_post/widget/media_url_input_widget.dart';
import 'package:do_host/view/post/content_post/widget/post_content_input_widget.dart';
import 'package:do_host/view/post/content_post/widget/post_submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/post_content_bloc/post_content_bloc.dart';
import '../../../dependency_injection/locator.dart';

class PostContentWidget extends StatefulWidget {
  final String userId;
  const PostContentWidget({super.key, required this.userId});

  @override
  State<PostContentWidget> createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends State<PostContentWidget> {
  late PostContentBloc _postContentBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _postContentBloc = PostContentBloc(postApiRepository: getIt());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postContentBloc.add(UserIdChanged(userId: widget.userId));
    });
  }

  @override
  void dispose() {
    _postContentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _postContentBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Post Your Content',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.buttonColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
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
                        children: [
                          SizedBox(height: 35),
                          PostContentInputWidget(),
                          SizedBox(height: 20),
                          MediaUrlWidget(),
                          SizedBox(height: 20),
                          PostSubmitButton(formKey: _formKey),
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
