import 'package:do_host/repository/user_followers_api/user_followers_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../model/movie_list/movie_list_model.dart';
import '../../model/user_followers/follower_model.dart';
import '../../utils/app_url.dart';

/// Implementation of [MoviesApiRepository] for making HTTP requests to fetch movies list.
class UserFollowersHttpApiRepository implements UserFollowersApiRepository {
  final _apiServices = NetworkApiService();

  /// Fetches the list of movies from the API.
  ///
  /// Returns a [MovieListModel] representing the list of movies.
  @override
  Future<FollowerResponse> fetchUserFollowersList() async {
    final response = await _apiServices.getApi(
      AppUrl.popularMoviesListEndPoint,
      headers: {},
    );
    return FollowerResponse.fromJson(response);
  }
}
