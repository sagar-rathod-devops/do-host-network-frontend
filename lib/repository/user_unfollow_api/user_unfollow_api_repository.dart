import 'package:do_host/model/user_unfollow/user_unfollow_model.dart';

abstract class UserUnfollowApiRepository {
  Future<UserUnfollowModel> userUnfollowApi(dynamic data);
}
