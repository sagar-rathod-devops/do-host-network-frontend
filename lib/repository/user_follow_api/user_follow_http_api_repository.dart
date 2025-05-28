import 'package:do_host/model/user_follow/user_follow_model.dart';
import 'package:do_host/repository/user_follow_api/user_follow_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class UserFollowHttpApiRepository implements UserFollowApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<UserFollowModel> userFollowApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.forgotPasswordEndPoint,
      data,
      headers: {},
    );
    return UserFollowModel.fromJson(response);
  }
}
