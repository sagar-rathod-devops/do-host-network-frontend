import 'package:do_host/model/user_video/user_video_model.dart';

abstract class UserVideoApiRepository {
  Future<UserVideoModel> userVideoApi(dynamic data);
}
