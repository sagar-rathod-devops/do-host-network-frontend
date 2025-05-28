import 'package:do_host/model/user_education/user_education_model.dart';

abstract class UserEducationApiRepository {
  Future<UserEducationModel> userEducationApi(dynamic data);
}
