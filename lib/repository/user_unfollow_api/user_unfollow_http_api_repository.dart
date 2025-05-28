import 'package:do_host/model/user_unfollow/user_unfollow_model.dart';
import 'package:do_host/repository/user_unfollow_api/user_unfollow_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class UserUnfollowHttpApiRepository implements UserUnfollowApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<UserUnfollowModel> userUnfollowApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.forgotPasswordEndPoint,
      data,
      headers: {},
    );
    return UserUnfollowModel.fromJson(response);
  }
}
