import 'package:flutter/material.dart';
import '../../../../configs/routes/routes_name.dart'; // Importing the route names
import '../../../../services/storage/local_storage.dart'; // Importing the LocalStorage class for managing local storage

import '../../../configs/color/color.dart'; // Importing app localizations for translated text

/// A widget representing the logout button.
class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        LocalStorage localStorage = LocalStorage();
        localStorage.clearValue('token').then((value) {
          localStorage.clearValue('isLogin');
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.login,
            (route) => false,
          ); // Navigating to the login screen after clearing token and isLogin value
        });
      },
      child: Center(child: Icon(Icons.logout, color: AppColors.whiteColor)),
    );
  }
}
