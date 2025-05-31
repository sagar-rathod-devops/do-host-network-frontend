import '../../model/user_education_get/user_education_get_model.dart';

abstract class UserEducationGetApiRepository {
  Future<UserEducationListResponse> fetchUserEducationList(String userId);
}
