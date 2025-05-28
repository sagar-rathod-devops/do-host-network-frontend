import 'package:do_host/model/post_like/post_like_model.dart';
import 'package:do_host/repository/post_like_api/post_like_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class PostLikeHttpApiRepository implements PostLikeApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<PostLikeModel> postLikeApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.forgotPasswordEndPoint,
      data,
      headers: {},
    );
    return PostLikeModel.fromJson(response);
  }
}
