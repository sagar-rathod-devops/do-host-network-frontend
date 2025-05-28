import '../../model/post_comments_get/comment_model.dart';

abstract class PostCommentsGetApiRepository {
  Future<CommentListResponse> fetchPostCommentsList();
}
