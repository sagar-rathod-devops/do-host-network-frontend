import 'package:do_host/repository/post_likes_get_api/post_likes_get_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../model/movie_list/movie_list_model.dart';
import '../../model/post_likes_get/like_model.dart';
import '../../utils/app_url.dart';

/// Implementation of [MoviesApiRepository] for making HTTP requests to fetch movies list.
class PostLikesGetHttpApiRepository implements PostLikesGetApiRepository {
  final _apiServices = NetworkApiService();

  /// Fetches the list of movies from the API.
  ///
  /// Returns a [MovieListModel] representing the list of movies.
  @override
  Future<LikeResponse> fetchPostLikesList() async {
    final response = await _apiServices.getApi(
      AppUrl.popularMoviesListEndPoint,
      headers: {},
    );
    return LikeResponse.fromJson(response);
  }
}
