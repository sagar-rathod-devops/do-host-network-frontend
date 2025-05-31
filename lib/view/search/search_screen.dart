import 'package:do_host/bloc/all_user_profile_get_bloc/bloc/all_user_profile_get_bloc_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/configs/components/internet_exception_widget.dart';
import 'package:do_host/data/response/status.dart';
import 'package:do_host/dependency_injection/locator.dart';
import 'package:do_host/model/all_user_profile_get/all_user_profile_get_model.dart';
import 'package:do_host/repository/response_api_repository.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import 'package:do_host/view/search/search_user_datails_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readmore/readmore.dart';

class SearchScreen extends StatefulWidget {
  final String? userId;
  const SearchScreen({super.key, required this.userId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late AllUserProfileGetBlocBloc allUserProfileGetBlocBloc;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _followedUserIds = {};
  final responseApi = ResponseApiRepository();
  String _searchQuery = '';
  List<AllUserProfile> _filteredProfiles = [];

  @override
  void initState() {
    super.initState();
    allUserProfileGetBlocBloc = AllUserProfileGetBlocBloc(
      allUserProfileGetApiRepository: getIt(),
    );
    _searchController.addListener(_onSearchChanged);

    responseApi
        .getFollowedUserIds(widget.userId!)
        .then((followedIds) {
          setState(() {
            _followedUserIds.addAll(followedIds);
          });
          allUserProfileGetBlocBloc.add(AllUserProfileGetFetch());
        })
        .catchError((error) {
          debugPrint("Error fetching followed users: $error");
          allUserProfileGetBlocBloc.add(AllUserProfileGetFetch());
        });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
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
        ? contentWidth // Mobile
        : contentWidth < 1100
        ? 600 // Tablet/Web Small
        : 800; // Desktop/Web Large

    return Scaffold(
      body: BlocProvider(
        create: (_) => allUserProfileGetBlocBloc,
        child: BlocBuilder<AllUserProfileGetBlocBloc, AllUserProfileGetBlocState>(
          buildWhen: (previous, current) =>
              previous.allUserProfileGetList != current.allUserProfileGetList,
          builder: (context, state) {
            switch (state.allUserProfileGetList.status) {
              case Status.loading:
                return const Center(
                  child: SpinKitSpinningLines(
                    color: AppColors.buttonColor,
                    size: 50.0,
                  ),
                );

              case Status.error:
                return InterNetExceptionWidget(
                  onPress: () {
                    // Add the logic to retry the API call or reload the content
                    context.read<AllUserProfileGetBlocBloc>().add(
                      AllUserProfileGetFetch(),
                    );
                  },
                );

              case Status.completed:
                final rawData = state.allUserProfileGetList.data;
                final profiles = (rawData?.profiles ?? [])
                    .where((profile) => profile.userId != widget.userId)
                    .toList();

                _filteredProfiles = _searchQuery.isEmpty
                    ? profiles
                    : profiles.where((profile) {
                        final name = profile.fullName.toLowerCase();
                        final designation = profile.designation.toLowerCase();
                        final org = profile.organization.toLowerCase();
                        return name.contains(_searchQuery) ||
                            designation.contains(_searchQuery) ||
                            org.contains(_searchQuery);
                      }).toList();

                return Center(
                  child: SizedBox(
                    width: maxContentWidth,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText:
                                  'Search by name, designation, or organization...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.buttonColor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.buttonColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.buttonColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _filteredProfiles.isEmpty
                              ? const Center(child: Text("No profiles found."))
                              : ListView.builder(
                                  itemCount: _filteredProfiles.length,
                                  itemBuilder: (context, index) {
                                    final user = _filteredProfiles[index];
                                    final isFollowing = _followedUserIds
                                        .contains(user.userId ?? '');

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchUserDetailsScreen(
                                                  userId: user.userId,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 2,
                                        ),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        user.profileImage !=
                                                            null
                                                        ? NetworkImage(
                                                            user.profileImage!,
                                                          )
                                                        : const AssetImage(
                                                                'assets/images/app_icon.png',
                                                              )
                                                              as ImageProvider,
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          user.fullName,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          user.designation,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                        ),
                                                        Text(
                                                          user.organization,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        ReadMoreText(
                                                          user.professionalSummary,
                                                          trimLines: 3,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          trimCollapsedText:
                                                              'Show more',
                                                          trimExpandedText:
                                                              'Show less',
                                                          colorClickableText:
                                                              AppColors
                                                                  .buttonColor,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                          moreStyle:
                                                              const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .buttonColor,
                                                              ),
                                                          lessStyle:
                                                              const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .buttonColor,
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
                                                  isFollowing
                                                      ? Icons.check
                                                      : Icons.person_add,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  isFollowing
                                                      ? 'Following'
                                                      : 'Follow',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isFollowing
                                                      ? Colors.grey
                                                      : AppColors.buttonColor,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6,
                                                      ),
                                                  minimumSize: const Size(
                                                    80,
                                                    32,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final currentUserFullName =
                                                      SessionController
                                                          .user
                                                          .fullName;

                                                  if (currentUserFullName
                                                      .trim()
                                                      .isEmpty) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Please update your profile with your full name before following users.",
                                                        ),
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  if (isFollowing) {
                                                    await responseApi
                                                        .unfollowUser(
                                                          user.userId ?? '',
                                                        );
                                                    await responseApi.sendNotification(
                                                      receiverId:
                                                          user.userId ?? '',
                                                      message:
                                                          "$currentUserFullName has unfollowed you.",
                                                      type: "unfollow",
                                                      // omit postId here since it's not related to a post
                                                    );
                                                    setState(() {
                                                      _followedUserIds.remove(
                                                        user.userId,
                                                      );
                                                    });
                                                  } else {
                                                    await responseApi
                                                        .followUser(
                                                          user.userId ?? '',
                                                        );
                                                    await responseApi.sendNotification(
                                                      receiverId:
                                                          user.userId ?? '',
                                                      message:
                                                          "$currentUserFullName started following you.",
                                                      type: "follow",
                                                      // omit postId here as well
                                                    );
                                                    setState(() {
                                                      _followedUserIds.add(
                                                        user.userId ?? '',
                                                      );
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                );

              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
