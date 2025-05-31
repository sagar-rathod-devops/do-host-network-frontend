import '../../model/user_experience_get/user_experience_get_model.dart';

abstract class UserExperienceGetApiRepository {
  Future<UserExperienceListResponse> fetchUserExperienceList(String userId);
}
