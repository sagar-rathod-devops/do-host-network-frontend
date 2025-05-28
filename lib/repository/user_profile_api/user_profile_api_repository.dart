import 'dart:io';

import 'package:do_host/model/user_profile/user_profile_model.dart';

abstract class UserProfileApiRepository {
  Future<UserProfileModel> userProfileApi(dynamic data, File? profileImage);

  Future<UserProfileModel> userProfileUpdateApi(
    dynamic data,
    File? profileImage,
  );
}
