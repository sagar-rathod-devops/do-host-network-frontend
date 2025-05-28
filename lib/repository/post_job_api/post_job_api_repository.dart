import 'package:do_host/model/post_job/post_job_model.dart';

abstract class PostJobApiRepository {
  Future<PostJobModel> postJobApi(dynamic data);
}
