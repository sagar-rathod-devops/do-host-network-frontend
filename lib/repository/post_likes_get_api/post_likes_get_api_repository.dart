import '../../model/post_likes_get/like_model.dart';

abstract class PostLikesGetApiRepository {
  Future<LikeResponse> fetchPostLikesList();
}
