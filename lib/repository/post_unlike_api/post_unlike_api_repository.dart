import 'package:do_host/model/post_unlike/post_unlike_model.dart';

abstract class PostUnlikeApiRepository {
  Future<PostUnlikeModel> postUnlikeApi(dynamic data);
}
