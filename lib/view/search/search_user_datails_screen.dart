import 'package:do_host/bloc/all_user_profile_get_bloc/bloc/all_user_profile_get_bloc_bloc.dart';
import 'package:do_host/bloc/user_education_get_bloc/user_education_get_bloc.dart';
import 'package:do_host/bloc/user_experience_get_bloc/user_experience_get_bloc.dart';
import 'package:do_host/bloc/user_profile_get_bloc/user_profile_get_bloc.dart';
import 'package:do_host/bloc/user_video_bloc/user_video_bloc.dart';
import 'package:do_host/bloc/user_video_get_bloc/user_video_get_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/configs/components/internet_exception_widget.dart';
import 'package:do_host/data/response/status.dart';
import 'package:do_host/dependency_injection/locator.dart';
import 'package:do_host/model/all_user_profile_get/all_user_profile_get_model.dart';
import 'package:do_host/model/user_education_get/user_education_get_model.dart';
import 'package:do_host/model/user_experience_get/user_experience_get_model.dart';
import 'package:do_host/model/user_profile_get/user_profile_get_model.dart';
import 'package:do_host/repository/response_api_repository.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import 'package:do_host/view/profile/user_stats_widgets.dart';
import 'package:do_host/view/profile/user_video/user_video_get_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class SearchUserDetailsScreen extends StatefulWidget {
  final String userId;
  const SearchUserDetailsScreen({super.key, required this.userId});

  @override
  State<SearchUserDetailsScreen> createState() =>
      _SearchUserDetailsScreenState();
}

class _SearchUserDetailsScreenState extends State<SearchUserDetailsScreen> {
  // Inside your widget class

  late final AllUserProfileGetBlocBloc allUserProfileGetBlocBloc;
  late final UserProfileGetBloc userProfileGetBloc;
  late final UserEducationGetBloc userEducationGetBloc;
  late final UserExperienceGetBloc userExperienceGetBloc;
  late final UserVideoGetBloc userVideoGetBloc;
  late final UserVideoBloc userVideoBloc;
  // late FollowUnfollowBloc followUnfollowBloc;

  Set<String> _followedUserIds = {};

  VideoPlayerController? _controller;
  final responseApi = ResponseApiRepository();

  List<UserEducation> educationList = [];
  List<UserExperience> experiences = [];

  @override
  void initState() {
    super.initState();

    userProfileGetBloc = UserProfileGetBloc(
      userProfileGetApiRepository: getIt(),
    );
    userEducationGetBloc = UserEducationGetBloc(
      userEducationGetApiRepository: getIt(),
    );
    userExperienceGetBloc = UserExperienceGetBloc(
      userExperienceGetApiRepository: getIt(),
    );
    userVideoGetBloc = UserVideoGetBloc(userVideoGetApiRepository: getIt());
    userVideoBloc = UserVideoBloc(userVideoApiRepository: getIt());
    allUserProfileGetBlocBloc = AllUserProfileGetBlocBloc(
      allUserProfileGetApiRepository: getIt(),
    );

    userProfileGetBloc.add(UserProfileGetFetch(widget.userId!));
    userEducationGetBloc.add(UserEducationGetFetch(widget.userId!));
    userExperienceGetBloc.add(UserExperienceGetFetch(widget.userId!));
    userVideoGetBloc.add(UserVideoGetFetch(userId: widget.userId!));

    _loadFollowedUsers();
  }

  Future<void> _loadFollowedUsers() async {
    try {
      final ids = await responseApi.getFollowedUserIds(widget.userId!);
      setState(() {
        _followedUserIds.clear();
        _followedUserIds.addAll(ids);
      });
    } catch (e) {
      debugPrint('Failed to load followed users: $e');
    }
  }

  void _refreshFollowedUserIdsAndFetch() async {
    try {
      final followedIds = await responseApi.getFollowedUserIds(widget.userId!);
      setState(() {
        _followedUserIds
          ..clear()
          ..addAll(followedIds);
      });
    } catch (e) {
      debugPrint("Error fetching followed users: $e");
    } finally {
      allUserProfileGetBlocBloc.add(AllUserProfileGetFetch());
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    userProfileGetBloc.close();
    userEducationGetBloc.close();
    userExperienceGetBloc.close();
    userVideoGetBloc.close();
    userVideoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double contentWidth = MediaQuery.of(context).size.width;

    // Responsive width for different platforms
    double maxContentWidth = contentWidth < 600
        ? contentWidth // Mobile
        : contentWidth < 1100
        ? 600 // Tablet/Web Small
        : 800; // Desktop/Web Large

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              userProfileGetBloc..add(UserProfileGetFetch(widget.userId!)),
        ),
        BlocProvider(
          create: (_) =>
              userEducationGetBloc..add(UserEducationGetFetch(widget.userId!)),
        ),
        BlocProvider(
          create: (_) =>
              userExperienceGetBloc
                ..add(UserExperienceGetFetch(widget.userId!)),
        ),

        BlocProvider(create: (_) => userVideoGetBloc),
        BlocProvider(create: (_) => userVideoBloc),
      ],
      child: Scaffold(
        appBar: UserVideoGetWidget(
          userId: widget.userId!,
        ), // ✅ Now has access to both blocs
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// USER PROFILE SECTION
                  BlocBuilder<UserProfileGetBloc, UserProfileGetState>(
                    buildWhen: (previous, current) =>
                        previous.userProfile != current.userProfile,
                    builder: (context, state) {
                      final status = state.userProfile.status;
                      final allUserProfile = state.userProfile.data;

                      if (status == Status.loading) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: AppColors.buttonColor,
                            size: 50.0,
                          ),
                        );
                      }

                      if (status == Status.error) {
                        return InterNetExceptionWidget(
                          onPress: () => userProfileGetBloc.add(
                            UserProfileGetFetch(widget.userId!),
                          ),
                        );
                      }

                      if (allUserProfile == null) {
                        return const Center(
                          child: Text("No user profile found."),
                        );
                      }

                      final isFollowing = _followedUserIds.contains(
                        allUserProfile.userId,
                      );

                      return _buildUserProfileGetCard(
                        context: context,
                        profile: allUserProfile,
                        isFollowing: isFollowing,
                        responseApi: responseApi,
                        followedUserIds: _followedUserIds,
                        setState: setState,
                      );
                    },
                  ),

                  const SizedBox(height: 2),
                  UserStatsWidget(userId: widget.userId!),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Education",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<UserEducationGetBloc, UserEducationGetState>(
                    buildWhen: (previous, current) =>
                        previous.userEducationGetList !=
                        current.userEducationGetList,
                    builder: (context, state) {
                      final status = state.userEducationGetList.status;

                      if (status == Status.loading) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: AppColors.buttonColor,
                            size: 50.0,
                          ),
                        );
                      }

                      final fetchedList =
                          state.userEducationGetList.data?.data ?? [];
                      if (educationList.isEmpty) {
                        educationList = List<UserEducation>.from(fetchedList);
                      }

                      return buildUserEducationGetCard(educationList, context);
                    },
                  ),

                  const SizedBox(height: 12),

                  /// EXPERIENCE SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Experience",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<UserExperienceGetBloc, UserExperienceGetState>(
                    buildWhen: (previous, current) =>
                        previous.userExperienceGetList !=
                        current.userExperienceGetList,
                    builder: (context, state) {
                      if (state.userExperienceGetList.status ==
                          Status.loading) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: AppColors.buttonColor,
                            size: 50.0,
                          ),
                        );
                      }

                      final fetchedExperience =
                          state.userExperienceGetList.data?.data ?? [];

                      experiences = fetchedExperience;

                      return buildUserExperienceGetCards(context, experiences);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileGetCard({
    required BuildContext context,
    required UserProfileResponse profile,
    required bool isFollowing,
    required ResponseApiRepository responseApi,
    required Set<String> followedUserIds,
    required Function(void Function()) setState,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile Image + Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage:
                            profile.profileImage?.isNotEmpty == true
                            ? NetworkImage(profile.profileImage!)
                            : null,
                        child: profile.profileImage?.isEmpty ?? true
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.fullName ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.badge,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    profile.designation ?? '',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    profile.location ?? '',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Email
                  Row(
                    children: [
                      const Icon(Icons.email, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          profile.email ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Phone
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        profile.contactNumber ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  const Text(
                    "Professional Summary:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.professionalSummary ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 12),

                  if ((profile.organization ?? '').isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.business,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          profile.organization!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // /// Follow/Unfollow Button
          // Positioned(
          //   top: 12,
          //   right: 12,
          //   child: ElevatedButton.icon(
          //     icon: Icon(
          //       isFollowing ? Icons.check : Icons.person_add,
          //       size: 18,
          //       color: Colors.white,
          //     ),
          //     label: Text(
          //       isFollowing ? 'Following' : 'Follow',
          //       style: const TextStyle(fontSize: 12, color: Colors.white),
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: isFollowing
          //           ? Colors.grey
          //           : AppColors.buttonColor,
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 10,
          //         vertical: 6,
          //       ),
          //       minimumSize: const Size(80, 32),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //     ),
          //     onPressed: () async {
          //       _toggleFollow(profile.userId!, isFollowing);
          //       // final currentUserFullName =
          //       //     SessionController.user.fullName?.trim() ?? '';

          //       // if (currentUserFullName.isEmpty) {
          //       //   ScaffoldMessenger.of(context).showSnackBar(
          //       //     const SnackBar(
          //       //       content: Text(
          //       //         "Please update your profile with your full name before following users.",
          //       //       ),
          //       //     ),
          //       //   );
          //       //   return;
          //       // }

          //       // final userId =
          //       //     profile.userId ?? ''; // Ensure profile has `userId`
          //       // if (userId.isEmpty) return;

          //       // if (isFollowing) {
          //       //   await responseApi.unfollowUser(userId);
          //       //   await responseApi.sendNotification(
          //       //     receiverId: userId,
          //       //     message: "$currentUserFullName has unfollowed you.",
          //       //     type: "unfollow",
          //       //   );
          //       //   setState(() {
          //       //     followedUserIds.remove(userId);
          //       //   });
          //       // } else {
          //       //   await responseApi.followUser(userId);
          //       //   await responseApi.sendNotification(
          //       //     receiverId: userId,
          //       //     message: "$currentUserFullName started following you.",
          //       //     type: "follow",
          //       //   );
          //       //   setState(() {
          //       //     followedUserIds.add(userId);
          //       //   });
          //       // }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> _toggleFollow(String userId, bool currentlyFollowing) async {
    final currentUserFullName = SessionController.user.fullName?.trim() ?? '';
    if (currentUserFullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please update your profile with your full name before following users.',
          ),
        ),
      );
      return;
    }

    try {
      if (currentlyFollowing) {
        await responseApi.unfollowUser(userId);
        await responseApi.sendNotification(
          receiverId: userId,
          message: "$currentUserFullName has unfollowed you.",
          type: "unfollow",
        );
        setState(() {
          _followedUserIds.remove(userId);
        });
      } else {
        await responseApi.followUser(userId);
        await responseApi.sendNotification(
          receiverId: userId,
          message: "$currentUserFullName started following you.",
          type: "follow",
        );
        setState(() {
          _followedUserIds.add(userId);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update follow status: $e')),
      );
    }
  }

  // Build Education Cards
  Widget buildUserEducationGetCard(
    List<UserEducation> educationList,
    BuildContext context,
  ) {
    if (educationList.isEmpty) {
      return const Center(child: Text('No Education Data Available'));
    }
    // Sort by year descending
    educationList.sort((a, b) => b.year.compareTo(a.year));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: educationList.length,
      itemBuilder: (context, index) {
        final edu = educationList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Degree + Field + Delete
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${edu.degree} in ${edu.fieldOfStudy}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Institution
                  Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        size: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          edu.institutionName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Year + Grade
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Year: ${edu.year}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.grade, size: 18, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        "Grade: ${edu.grade}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build Experience Cards
  Widget buildUserExperienceGetCards(
    BuildContext context,
    List<UserExperience> experiences,
  ) {
    if (experiences.isEmpty) {
      return const Center(child: Text('No Experience Data Available'));
    }

    // Sort by startDate descending
    experiences.sort((a, b) {
      if (a.startDate == null && b.startDate == null) return 0;
      if (a.startDate == null) return 1;
      if (b.startDate == null) return -1;
      return b.startDate!.compareTo(a.startDate!);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final exp = experiences[index];
        final startDate = exp.startDate != null
            ? DateFormat.yMMM().format(exp.startDate!)
            : 'N/A';
        final endDate = exp.endDate != null
            ? DateFormat.yMMM().format(exp.endDate!)
            : 'Present';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Delete
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.work,
                              color:
                                  Colors.blue, // optional: customize icon color
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                exp.jobTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.business, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        exp.companyName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  DefaultTextStyle.merge(
                    // style: const TextStyle(color: Colors.black),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            exp.location,
                            style: const TextStyle(
                              fontSize: 14,
                              // color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$startDate - $endDate",
                          style: const TextStyle(
                            fontSize: 14,
                            // color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Job Description:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exp.jobDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),

                  const SizedBox(height: 16),

                  if (exp.achievements.isNotEmpty) ...[
                    const Text(
                      "Achievements:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exp.achievements,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
