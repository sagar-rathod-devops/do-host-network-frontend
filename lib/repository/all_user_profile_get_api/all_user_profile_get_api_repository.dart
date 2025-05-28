import '../../model/all_user_profile_get/all_user_profile_get_model.dart';

abstract class AllUserProfileGetApiRepository {
  Future<AllUserProfileResponse> fetchAllUserProfileList();
}
