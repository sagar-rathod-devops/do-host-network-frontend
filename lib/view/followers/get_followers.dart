import 'package:do_host/bloc/all_user_profile_get_bloc/bloc/all_user_profile_get_bloc_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/dependency_injection/locator.dart';
import 'package:do_host/model/all_user_profile_get/all_user_profile_get_model.dart';
import 'package:do_host/repository/response_api_repository.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import 'package:do_host/view/search/search_user_datails_screen.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/response/status.dart';

class GetFollowers extends StatefulWidget {
  final String? userId;

  const GetFollowers({super.key, required this.userId});

  @override
  State<GetFollowers> createState() => _GetFollowersState();
}

class _GetFollowersState extends State<GetFollowers> {
  late AllUserProfileGetBlocBloc allUserProfileGetBlocBloc;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _followerUserIds = {};
  final responseApi = ResponseApiRepository();

  @override
  void initState() {
    super.initState();
    allUserProfileGetBlocBloc = AllUserProfileGetBlocBloc(
      allUserProfileGetApiRepository: getIt(),
    );
    _searchController.addListener(() => setState(() {}));

    responseApi
        .getFollowers(widget.userId!)
        .then((followersResponse) {
          setState(() {
            _followerUserIds.addAll(followersResponse.followers);
          });
          allUserProfileGetBlocBloc.add(AllUserProfileGetFetch());
        })
        .catchError((error) {
          debugPrint("Error fetching followers: $error");
          allUserProfileGetBlocBloc.add(AllUserProfileGetFetch());
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    allUserProfileGetBlocBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = MediaQuery.of(context).size.width;
    final double maxContentWidth = contentWidth < 600
        ? contentWidth
        : contentWidth < 1100
        ? 600
        : 800;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: maxContentWidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: "Search followers...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child:
                    BlocBuilder<
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
                                state.allUserProfileGetList.data!.profiles;

                            final followerProfiles = allProfiles.where((
                              profile,
                            ) {
                              final isFollower = _followerUserIds.contains(
                                profile.userId,
                              );
                              final query = _searchController.text
                                  .toLowerCase();
                              final nameMatch = profile.fullName
                                  .toLowerCase()
                                  .contains(query);
                              return isFollower && nameMatch;
                            }).toList();

                            if (followerProfiles.isEmpty) {
                              return const Center(
                                child: Text("No followers found."),
                              );
                            }

                            return ListView.builder(
                              itemCount: followerProfiles.length,
                              itemBuilder: (context, index) {
                                final user = followerProfiles[index];
                                final isFollowing = _followerUserIds.contains(
                                  user.userId ?? '',
                                );
                                return buildFollowerCard(user, isFollowing);
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
    );
  }

  Widget buildFollowerCard(AllUserProfile user, bool isFollowing) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchUserDetailsScreen(userId: user.userId),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                            color: AppColors.buttonColor,
                          ),
                          lessStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.buttonColor,
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  final currentUserFullName = SessionController.user.fullName;

                  if (currentUserFullName.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please update your profile with your full name before following users.",
                        ),
                      ),
                    );
                    return;
                  }

                  if (isFollowing) {
                    await responseApi.unfollowUser(user.userId ?? '');
                    await responseApi.sendNotification(
                      receiverId: user.userId ?? '',
                      message: "$currentUserFullName has unfollowed you.",
                      type: "unfollow",
                    );
                    setState(() {
                      _followerUserIds.remove(user.userId);
                    });
                  } else {
                    await responseApi.followUser(user.userId ?? '');
                    await responseApi.sendNotification(
                      receiverId: user.userId ?? '',
                      message: "$currentUserFullName started following you.",
                      type: "follow",
                    );
                    setState(() {
                      _followerUserIds.add(user.userId ?? '');
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
