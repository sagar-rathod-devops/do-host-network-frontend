import '../../model/post_comment/post_comment_model.dart';

abstract class PostCommentApiRepository {
  Future<PostCommentModel> postCommentApi(dynamic data);
}
