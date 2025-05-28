import 'package:do_host/repository/post_comments_get_api/post_comments_get_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../model/movie_list/movie_list_model.dart';
import '../../model/post_comments_get/comment_model.dart';
import '../../utils/app_url.dart';

/// Implementation of [MoviesApiRepository] for making HTTP requests to fetch movies list.
class PostCommentsGetHttpApiRepository implements PostCommentsGetApiRepository {
  final _apiServices = NetworkApiService();

  /// Fetches the list of movies from the API.
  ///
  /// Returns a [MovieListModel] representing the list of movies.
  @override
  Future<CommentListResponse> fetchPostCommentsList() async {
    final response = await _apiServices.getApi(
      AppUrl.popularMoviesListEndPoint,
      headers: {},
    );
    return CommentListResponse.fromJson(response);
  }
}
