import 'package:do_host/model/user_experience/user_experience_model.dart';

abstract class UserExperienceApiRepository {
  Future<UserExperienceModel> userExperienceApi(dynamic data);
}
