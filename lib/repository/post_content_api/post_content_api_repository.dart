import 'package:do_host/model/post_content/post_content_model.dart';

abstract class PostContentApiRepository {
  Future<PostContentModel> postContentApi(dynamic data);
}
