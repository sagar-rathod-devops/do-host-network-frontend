import 'package:do_host/bloc/all_user_profile_get_bloc/bloc/all_user_profile_get_bloc_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/data/response/status.dart';
import 'package:do_host/dependency_injection/locator.dart';
import 'package:do_host/model/all_user_profile_get/all_user_profile_get_model.dart';
import 'package:do_host/repository/response_api_repository.dart';
import 'package:do_host/view/search/search_user_datails_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

class GetFollowings extends StatefulWidget {
  final String? userId;

  const GetFollowings({super.key, required this.userId});

  @override
  State<GetFollowings> createState() => _GetFollowingsState();
}

class _GetFollowingsState extends State<GetFollowings> {
  late AllUserProfileGetBlocBloc allUserProfileGetBlocBloc;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _followingUserIds = {};
  final responseApi = ResponseApiRepository();

  String _searchQuery = '';
  bool _isLoadingFollowings = true;

  @override
  void initState() {
    super.initState();
    allUserProfileGetBlocBloc = AllUserProfileGetBlocBloc(
      allUserProfileGetApiRepository: getIt(),
    );

    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });

    _loadFollowingsAndFetchProfiles();
  }

  Future<void> _loadFollowingsAndFetchProfiles() async {
    try {
      final response = await responseApi.getFollowings(widget.userId!);
      setState(() {
        _followingUserIds.addAll(response.followings);
        _isLoadingFollowings = false;
      });
      allUserProfileGetBlocBloc.add(AllUserProfileGetFetch());
    } catch (e) {
      debugPrint("Error fetching followings: $e");
      setState(() => _isLoadingFollowings = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    allUserProfileGetBlocBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double maxWidth = screenWidth < 600
        ? screenWidth
        : (screenWidth < 1100 ? 600 : 800);

    return BlocProvider.value(
      value: allUserProfileGetBlocBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Following")),
        body: Center(
          child: SizedBox(
            width: maxWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Search followings...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoadingFollowings
                      ? const Center(child: CircularProgressIndicator())
                      : BlocBuilder<
                          AllUserProfileGetBlocBloc,
                          AllUserProfileGetBlocState
                        >(
                          bloc: allUserProfileGetBlocBloc,
                          builder: (context, state) {
                            switch (state.allUserProfileGetList.status) {
                              case Status.loading:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );

                              case Status.error:
                                return Center(
                                  child: Text(
                                    'Error: ${state.allUserProfileGetList.message}',
                                  ),
                                );

                              case Status.COMPLETED:
                                final allProfiles =
                                    state
                                        .allUserProfileGetList
                                        .data
                                        ?.profiles ??
                                    [];

                                final followingProfiles = allProfiles.where((
                                  profile,
                                ) {
                                  final userId = profile.userId ?? '';
                                  final nameMatch = profile.fullName
                                      .toLowerCase()
                                      .contains(_searchQuery);
                                  return _followingUserIds.contains(userId) &&
                                      nameMatch;
                                }).toList();

                                if (followingProfiles.isEmpty) {
                                  return const Center(
                                    child: Text("No followings found."),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: followingProfiles.length,
                                  itemBuilder: (context, index) {
                                    final user = followingProfiles[index];
                                    return buildFollowingCard(user);
                                  },
                                );

                              default:
                                return const SizedBox();
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFollowingCard(AllUserProfile user) {
    final isFollowing = _followingUserIds.contains(user.userId ?? '');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchUserDetailsScreen(userId: user.userId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage!)
                        : const AssetImage('assets/images/app_icon.png')
                              as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.designation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          user.organization,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ReadMoreText(
                          user.professionalSummary,
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          colorClickableText: AppColors.buttonColor,
                          style: const TextStyle(fontSize: 14),
                          moreStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          lessStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: ElevatedButton.icon(
                icon: Icon(
                  isFollowing ? Icons.check : Icons.person_add,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  isFollowing ? 'Following' : 'Follow',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFollowing
                      ? Colors.grey
                      : AppColors.buttonColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Optionally implement follow/unfollow logic here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
