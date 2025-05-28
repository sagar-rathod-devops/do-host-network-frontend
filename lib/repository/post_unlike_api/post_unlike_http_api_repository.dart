import 'package:do_host/model/post_unlike/post_unlike_model.dart';
import 'package:do_host/repository/post_unlike_api/post_unlike_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class PostUnlikeHttpApiRepository implements PostUnlikeApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<PostUnlikeModel> postUnlikeApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.forgotPasswordEndPoint,
      data,
      headers: {},
    );
    return PostUnlikeModel.fromJson(response);
  }
}
