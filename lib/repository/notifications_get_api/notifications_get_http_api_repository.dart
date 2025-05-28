// import 'package:do_host/repository/notifications_get_api/notifications_get_api_repository.dart';

// import '../../data/network/network_api_services.dart';
// import '../../model/movie_list/movie_list_model.dart';
// import '../../model/notifications_get/notification_list_model.dart';
// import '../../utils/app_url.dart';

// /// Implementation of [MoviesApiRepository] for making HTTP requests to fetch movies list.
// class NotificationsGetHttpApiRepository
//     implements NotificationsGetApiRepository {
//   final _apiServices = NetworkApiService();

//   /// Fetches the list of movies from the API.
//   ///
//   /// Returns a [MovieListModel] representing the list of movies.
//   @override
//   Future<NotificationListModel> fetchNotificationsList() async {
//     final response = await _apiServices.getApi(
//       AppUrl.popularMoviesListEndPoint,
//       headers: {},
//     );
//     return NotificationListModel.fromJson(response);
//   }
// }
