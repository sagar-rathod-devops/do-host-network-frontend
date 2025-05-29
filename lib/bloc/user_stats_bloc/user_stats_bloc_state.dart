part of 'user_stats_bloc_bloc.dart';

class UserStatsState {
  final int followers;
  final int followings;
  final int posts;
  final int likes;
  final int comments;
  final bool loading;
  final String? error;

  UserStatsState({
    this.followers = 0,
    this.followings = 0,
    this.posts = 0,
    this.likes = 0,
    this.comments = 0,
    this.loading = false,
    this.error,
  });

  UserStatsState copyWith({
    int? followers,
    int? followings,
    int? posts,
    int? likes,
    int? comments,
    bool? loading,
    String? error,
  }) {
    return UserStatsState(
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      posts: posts ?? this.posts,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
