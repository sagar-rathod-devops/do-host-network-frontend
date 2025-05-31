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

class FavouriteDetailScreen extends StatefulWidget {
  final String userId;
  final String description;
  final String timestamp;

  const FavouriteDetailScreen({
    super.key,
    required this.userId,
    required this.description,
    required this.timestamp,
  });

  @override
  State<FavouriteDetailScreen> createState() => _FavouriteDetailScreenState();
}

class _FavouriteDetailScreenState extends State<FavouriteDetailScreen> {
  late AllUserProfileGetBlocBloc allUserProfileGetBlocBloc;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _followedUserIds = {};
  final responseApi = ResponseApiRepository();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    allUserProfileGetBlocBloc = AllUserProfileGetBlocBloc(
      allUserProfileGetApiRepository: getIt(),
    );
    _searchController.addListener(_onSearchChanged);

    responseApi
        .getFollowedUserIds(widget.userId)
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Device type breakpoints
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;

    final double maxContentWidth = isMobile
        ? screenWidth
        : isTablet
        ? 600
        : 800;

    // Extract the first URL from the text
    final uriRegex = RegExp(r'(https?:\/\/[^\s]+)');
    final match = uriRegex.firstMatch(widget.description);
    final imageUrl = match?.group(0) ?? '';

    // Find 'your post' keyword (case-insensitive)
    final postKeyword = 'your post';
    final postIndex = widget.description.toLowerCase().indexOf(postKeyword);

    String firstUrl = '';
    String secondUrl = '';
    String thirdUrl = imageUrl;
    String fourthUrl = '';

    if (postIndex != -1 && imageUrl.isNotEmpty) {
      final keywordEndIndex = postIndex + postKeyword.length;

      // firstUrl: from start up to and including 'your post'
      firstUrl = widget.description.substring(0, keywordEndIndex).trim();

      // remainder text after 'your post'
      final afterPostText = widget.description
          .substring(keywordEndIndex)
          .trim();

      // split around the imageUrl
      final parts = afterPostText.split(imageUrl);

      secondUrl = parts[0].trim();
      fourthUrl = parts.length > 1 ? parts[1].trim() : '';
    } else {
      // fallback if keyword or URL missing
      firstUrl = widget.description;
      secondUrl = '';
      fourthUrl = '';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        iconTheme: const IconThemeData(color: AppColors.whiteColor), // <-- here
        title: const Text(
          "Notification Details",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
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
                    context.read<AllUserProfileGetBlocBloc>().add(
                      AllUserProfileGetFetch(),
                    );
                  },
                );
              case Status.completed:
                final rawData = state.allUserProfileGetList.data;
                final profiles = (rawData?.profiles ?? []);

                final AllUserProfile? user = profiles.firstWhere(
                  (profile) => profile.userId == widget.userId,
                  orElse: () => AllUserProfile(
                    userId: widget.userId,
                    id: '',
                    fullName: '',
                    designation: '',
                    organization: '',
                    professionalSummary: '',
                    location: '',
                    email: '',
                    contactNumber: '',
                    createdAt: '',
                    updatedAt: '',
                  ),
                );

                final isFollowing = _followedUserIds.contains(
                  user?.userId ?? '',
                );

                return Center(
                  child: SizedBox(
                    width: maxContentWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.all(8.0)),
                        Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          user?.profileImage != null
                                          ? NetworkImage(user!.profileImage!)
                                          : const AssetImage(
                                                  'assets/images/app_icon.png',
                                                )
                                                as ImageProvider,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user!.fullName,
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
                                            colorClickableText:
                                                AppColors.buttonColor,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
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
                                    isFollowing
                                        ? Icons.check
                                        : Icons.person_add,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    isFollowing ? 'Following' : 'Follow',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
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
                                    final currentUserFullName =
                                        SessionController.user.fullName;

                                    if (currentUserFullName.trim().isEmpty) {
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
                                      await responseApi.unfollowUser(
                                        user.userId ?? '',
                                      );
                                      await responseApi.sendNotification(
                                        receiverId: user.userId ?? '',
                                        message:
                                            "$currentUserFullName has unfollowed you.",
                                        type: "unfollow",
                                      );
                                      setState(() {
                                        _followedUserIds.remove(user.userId);
                                      });
                                    } else {
                                      await responseApi.followUser(
                                        user.userId ?? '',
                                      );
                                      await responseApi.sendNotification(
                                        receiverId: user.userId ?? '',
                                        message:
                                            "$currentUserFullName started following you.",
                                        type: "follow",
                                      );
                                      setState(() {
                                        _followedUserIds.add(user.userId ?? '');
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment
                                .topCenter, // Align content horizontally center and top vertically
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              constraints: BoxConstraints(
                                maxWidth: maxContentWidth,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (firstUrl.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: '📌 ',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: firstUrl,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color:
                                                          AppColors.buttonColor,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            ReadMoreText(
                                              secondUrl,
                                              trimLines: 3,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: 'Show more',
                                              trimExpandedText: 'Show less',
                                              colorClickableText:
                                                  AppColors.buttonColor,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                              moreStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.buttonColor,
                                              ),
                                              lessStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.buttonColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (thirdUrl != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.network(
                                              thirdUrl!,
                                              loadingBuilder:
                                                  (
                                                    BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return SizedBox(
                                                      height: 200,
                                                      child: Center(
                                                        child:
                                                            SpinKitSpinningLines(
                                                              color: AppColors
                                                                  .buttonColor,
                                                              size: 50.0,
                                                            ),
                                                      ),
                                                    );
                                                  },

                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const SizedBox.shrink();
                                                  },
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (fourthUrl.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: Text(
                                          fourthUrl,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),

                                    Text(
                                      'Timestamp: ${widget.timestamp}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
