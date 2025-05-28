import '../../model/user_video_get/user_video_model.dart';

abstract class UserVideoGetApiRepository {
  Future<UserVideoResponse> fetchUserVideoList();
}
