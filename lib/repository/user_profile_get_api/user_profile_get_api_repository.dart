import '../../model/user_profile_get/user_profile_get_model.dart';

abstract class UserProfileGetApiRepository {
  Future<UserProfileResponse> fetchUserProfile(String userId);
}
