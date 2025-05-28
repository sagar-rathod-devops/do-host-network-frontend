import 'package:do_host/model/post_comment/post_comment_model.dart';
import 'package:do_host/repository/post_comment_api/post_comment_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../utils/app_url.dart';

class PostCommentHttpApiRepository implements PostCommentApiRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<PostCommentModel> postCommentApi(dynamic data) async {
    dynamic response = await _apiServices.postApi(
      AppUrl.forgotPasswordEndPoint,
      data,
      headers: {},
    );
    return PostCommentModel.fromJson(response);
  }
}
