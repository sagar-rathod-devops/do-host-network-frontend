import 'package:do_host/model/post_like/post_like_model.dart';

abstract class PostLikeApiRepository {
  Future<PostLikeModel> postLikeApi(dynamic data);
}
