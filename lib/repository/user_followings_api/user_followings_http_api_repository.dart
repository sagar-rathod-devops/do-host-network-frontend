import 'package:do_host/repository/user_followings_api/user_followings_api_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../model/movie_list/movie_list_model.dart';
import '../../model/user_followings/following_model.dart';
import '../../utils/app_url.dart';

/// Implementation of [MoviesApiRepository] for making HTTP requests to fetch movies list.
class UserFollowingsHttpApiRepository implements UserFollowingsApiRepository {
  final _apiServices = NetworkApiService();

  /// Fetches the list of movies from the API.
  ///
  /// Returns a [MovieListModel] representing the list of movies.
  @override
  Future<FollowingResponse> fetchUserFollowingsList() async {
    final response = await _apiServices.getApi(
      AppUrl.popularMoviesListEndPoint,
      headers: {},
    );
    return FollowingResponse.fromJson(response);
  }
}
