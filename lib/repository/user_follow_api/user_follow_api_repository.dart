import 'package:do_host/model/user_follow/user_follow_model.dart';

abstract class UserFollowApiRepository {
  Future<UserFollowModel> userFollowApi(dynamic data);
}
