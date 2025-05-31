import 'package:do_host/bloc/user_stats_bloc/user_stats_bloc_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/repository/response_api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserStatsWidget extends StatelessWidget {
  final String userId;

  const UserStatsWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserStatsBloc(ResponseApiRepository())..add(LoadUserStats(userId)),
      child: BlocBuilder<UserStatsBloc, UserStatsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: SpinKitSpinningLines(
                color: AppColors.buttonColor,
                size: 50.0,
              ),
            );
          }

          final hasData = state.error == null;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          "Followers",
                          hasData ? state.followers : 0,
                        ),
                        _buildStatCard(
                          "Following",
                          hasData ? state.followings : 0,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard("Posts", hasData ? state.posts : 0),
                        const VerticalDivider(thickness: 1),
                        _buildStatCard("Likes", hasData ? state.likes : 0),
                        const VerticalDivider(thickness: 1),
                        _buildStatCard(
                          "Comments",
                          hasData ? state.comments : 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
