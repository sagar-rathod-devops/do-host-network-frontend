import 'package:do_host/model/post_all_content_get/post_model.dart';

abstract class PostAllContentGetApiRepository {
  Future<PostResponse> fetchPostAllContentList();
}
