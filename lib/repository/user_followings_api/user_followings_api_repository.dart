import '../../model/user_followings/following_model.dart';

abstract class UserFollowingsApiRepository {
  Future<FollowingResponse> fetchUserFollowingsList();
}
