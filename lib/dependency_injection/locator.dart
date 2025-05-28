import 'package:do_host/repository/all_user_profile_get_api/all_user_profile_get_api_repository.dart';
import 'package:do_host/repository/all_user_profile_get_api/all_user_profile_get_http_api_repository.dart';

import 'dependency_injection.dart';

// GetIt is a package used for service locator or to manage dependency injection
GetIt getIt = GetIt.instance;

class ServiceLocator {
  void servicesLocator() {
    getIt.registerLazySingleton<AuthApiRepository>(
      () => AuthHttpApiRepository(),
    ); // Registering AuthHttpApiRepository as a lazy singleton for AuthApiRepository
    getIt.registerLazySingleton<MoviesApiRepository>(
      () => MoviesHttpApiRepository(),
    ); // Registering MoviesHttpApiRepository as a lazy singleton for MoviesApiRepository
    getIt.registerLazySingleton<RegisterApiRepository>(
      () => RegisterHttpApiRepository(),
    );
    getIt.registerLazySingleton<ForgotPasswordApiRepository>(
      () => ForgotPasswordHttpApiRepository(),
    );
    getIt.registerLazySingleton<LogoutApiRepository>(
      () => LogoutHttpApiRepository(),
    );
    getIt.registerLazySingleton<ResetPasswordApiRepository>(
      () => ResetPasswordHttpApiRepository(),
    );
    getIt.registerLazySingleton<VerifyOtpApiRepository>(
      () => VerifyOtpHttpApiRepository(),
    );
    getIt.registerLazySingleton<NotificationsCreateApiRepository>(
      () => NotificationsCreateHttpApiRepository(),
    );
    getIt.registerLazySingleton<PostCommentApiRepository>(
      () => PostCommentHttpApiRepository(),
    );
    getIt.registerLazySingleton<PostContentApiRepository>(
      () => PostContentHttpApiRepository(),
    );
    getIt.registerLazySingleton<PostJobApiRepository>(
      () => PostJobHttpApiRepository(),
    );
    getIt.registerLazySingleton<PostLikeApiRepository>(
      () => PostLikeHttpApiRepository(),
    );
    getIt.registerLazySingleton<PostUnlikeApiRepository>(
      () => PostUnlikeHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserEducationApiRepository>(
      () => UserEducationHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserExperienceApiRepository>(
      () => UserExperienceHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserFollowApiRepository>(
      () => UserFollowHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserProfileApiRepository>(
      () => UserProfileHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserUnfollowApiRepository>(
      () => UserUnfollowHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserVideoApiRepository>(
      () => UserVideoHttpApiRepository(),
    );
    // getIt.registerLazySingleton<NotificationsGetApiRepository>(() => NotificationsGetHttpApiRepository());
    getIt.registerLazySingleton<PostAllContentGetApiRepository>(
      () => PostAllContentGetHttpApiRepository(),
    );
    getIt.registerLazySingleton<PostAllJobGetApiRepository>(
      () => PostAllJobGetHttpApiRepository(),
    );
    getIt.registerLazySingleton<PostCommentsGetApiRepository>(
      () => PostCommentsGetHttpApiRepository(),
    );
    getIt.registerLazySingleton<PostLikesGetApiRepository>(
      () => PostLikesGetHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserEducationGetApiRepository>(
      () => UserEducationGetHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserExperienceGetApiRepository>(
      () => UserExperienceGetHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserFollowersApiRepository>(
      () => UserFollowersHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserFollowingsApiRepository>(
      () => UserFollowingsHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserProfileGetApiRepository>(
      () => UserProfileGetHttpApiRepository(),
    );
    getIt.registerLazySingleton<UserVideoGetApiRepository>(
      () => UserVideoGetHttpApiRepository(),
    );
    getIt.registerLazySingleton<AllUserProfileGetApiRepository>(
      () => AllUserProfileGetHttpApiRepository(),
    );
  }
}
