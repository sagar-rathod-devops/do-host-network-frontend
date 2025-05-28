import '../../model/user_followers/follower_model.dart';

abstract class UserFollowersApiRepository {
  Future<FollowerResponse> fetchUserFollowersList();
}
