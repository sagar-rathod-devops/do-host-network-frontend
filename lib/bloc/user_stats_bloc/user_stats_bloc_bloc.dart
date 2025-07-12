import 'package:bloc/bloc.dart';
import 'package:do_host/repository/response_api_repository.dart';

part 'user_stats_bloc_event.dart';
part 'user_stats_bloc_state.dart';

class UserStatsBloc extends Bloc<UserStatsEvent, UserStatsState> {
  final ResponseApiRepository repository;

  UserStatsBloc(this.repository) : super(UserStatsState()) {
    on<LoadUserStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadUserStats event,
    Emitter<UserStatsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final followers = await repository.getFollowersCount(event.userId);
      final followings = await repository.getFollowingsCount(event.userId);
      final postsList = await repository.getUserPosts(event.userId) ?? [];

      int totalLikes = 0;
      int totalComments = 0;

      for (var post in postsList) {
        final postId = post['id'];
        if (postId == null) continue; // defensive null check

        final likes = await repository.getPostLikesCount(postId);
        final comments = await repository.getPostCommentsCount(postId);
        totalLikes += likes;
        totalComments += comments;
      }

      emit(
        state.copyWith(
          followers: followers,
          followings: followings,
          posts: postsList.length,
          likes: totalLikes,
          comments: totalComments,
          loading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
