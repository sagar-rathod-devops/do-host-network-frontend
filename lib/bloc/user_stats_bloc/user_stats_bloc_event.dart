part of 'user_stats_bloc_bloc.dart';

abstract class UserStatsEvent {}

class LoadUserStats extends UserStatsEvent {
  final String userId;
  LoadUserStats(this.userId);
}
