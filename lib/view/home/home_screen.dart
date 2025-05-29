// (Unchanged code you've written)

import 'dart:io';
import 'package:do_host/bloc/post_all_content_get_bloc/post_all_content_get_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/data/network/network_api_services.dart';
import 'package:do_host/data/response/status.dart';
import 'package:do_host/dependency_injection/locator.dart';
import 'package:do_host/repository/response_api_repository.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import 'package:do_host/utils/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:readmore/readmore.dart';

class HomeScreen extends StatefulWidget {
  final String? userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NetworkApiService _apiService = NetworkApiService();
  final SessionController _sessionController = SessionController();
  late final PostAllContentGetBloc postAllContentGetBloc;
  final Set<String> _likedPostIds = {};
  final Set<String> _showCommentFieldForPost = {};
  final Map<String, TextEditingController> _commentControllers = {};
  final Map<String, int> _likesCount = {};
  final Map<String, List<String>> _postComments = {};
  Map<String, List<String>> _postNewComments = {};
  final responseApi = ResponseApiRepository();

  @override
  void initState() {
    super.initState();

    postAllContentGetBloc = PostAllContentGetBloc(
      postAllContentGetApiRepository: getIt(),
    );
    _fetchAndSaveUserProfile();
    postAllContentGetBloc.stream.listen((state) {
      if (state is PostAllContentGetState &&
          state.postAllContentGetList.status == Status.completed) {
        final posts = state.postAllContentGetList.data?.posts ?? [];
        for (var post in posts) {
          final postId = post.postId;
          if (postId != null) {
            _likesCount[postId] = post.totalLikes ?? 0;
            _postComments.putIfAbsent(postId, () => []);
            // Clear local new comments for this post because server data is fresh
            _postNewComments.remove(postId);
          }
        }
        setState(() {});
      }
    });

    if (widget.userId != null) {
      responseApi
          .getLikedPostIds(widget.userId!)
          .then((likedIds) {
            setState(() {
              _likedPostIds.addAll(likedIds);
            });
          })
          .catchError((error) {
            debugPrint("Error fetching liked posts: $error");
          });
    }
  }

  Future<void> _fetchAndSaveUserProfile() async {
    try {
      // Get userId and token from session controller
      final userId = await _sessionController.getUserId();
      final token = await _sessionController.getToken();

      if (userId == null || userId.isEmpty) {
        debugPrint('UserId not found in session');
        return;
      }

      final url = "${AppUrl.baseUrl}/user/profile/$userId";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _apiService.getApi(url, headers: headers);

      if (response != null && response['full_name'] != null) {
        final fullName = response['full_name'] as String;

        // Update the full name in session storage
        await _sessionController.saveFullName(fullName);

        debugPrint('FullName saved to session: $fullName');
      } else {
        debugPrint('Failed to fetch profile or full_name missing');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  @override
  void dispose() {
    postAllContentGetBloc.close();
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> sharePost(String text, String? imageUrl) async {
    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode != 200) throw Exception('Failed to load image');

        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/shared_image.jpg').create();
        await file.writeAsBytes(bytes);

        await Share.shareXFiles([XFile(file.path)], text: text);
      } else {
        await Share.share(text);
      }
    } catch (e) {
      debugPrint("Error sharing post: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error sharing post: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double contentWidth = constraints.maxWidth;
        double maxContentWidth = contentWidth < 600
            ? contentWidth
            : contentWidth < 1100
            ? 600
            : 800;

        return Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: BlocProvider.value(
                value: postAllContentGetBloc..add(PostAllContentGetFetch()),
                child: BlocBuilder<PostAllContentGetBloc, PostAllContentGetState>(
                  builder: (context, state) {
                    switch (state.postAllContentGetList.status) {
                      case Status.loading:
                        return const Center(child: CircularProgressIndicator());

                      case Status.error:
                        final errorMsg =
                            state.postAllContentGetList.message ??
                            "Something went wrong!";
                        return Center(child: Text(errorMsg));

                      case Status.completed:
                        final posts =
                            state.postAllContentGetList.data?.posts ?? [];
                        if (posts.isEmpty) {
                          return const Center(child: Text("No posts found"));
                        }

                        return ListView.builder(
                          itemCount: posts.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final postId = post.postId;
                            if (postId == null) return const SizedBox();

                            final isLiked = _likedPostIds.contains(postId);
                            final showCommentField = _showCommentFieldForPost
                                .contains(postId);
                            final commentController = _commentControllers
                                .putIfAbsent(
                                  postId,
                                  () => TextEditingController(),
                                );
                            final commentCount =
                                (post.totalComments ?? 0) +
                                (_postNewComments[postId]?.length ?? 0);

                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundImage:
                                              (post.profileImage?.isNotEmpty ??
                                                  false)
                                              ? NetworkImage(post.profileImage!)
                                              : const AssetImage(
                                                      'assets/images/app_icon.png',
                                                    )
                                                    as ImageProvider,
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              post.fullName ?? 'XYZ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              post.designation ?? 'XYZ',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ReadMoreText(
                                      post.postContent ?? '',
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
                                    if (post.mediaUrl?.isNotEmpty ?? false)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: GestureDetector(
                                          onDoubleTap: () async {
                                            final fullName =
                                                await SessionController()
                                                    .getFullName();
                                            if (fullName == null ||
                                                fullName.trim().isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Please update your profile before liking posts.",
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            if (!isLiked) {
                                              await responseApi.likePost(
                                                postId,
                                              );
                                              await responseApi.sendNotification(
                                                receiverId: post.userId,
                                                message:
                                                    "$fullName liked your post. ${post.postContent} ${post.mediaUrl}",
                                                type: "like",
                                                postId: postId,
                                              );
                                              setState(() {
                                                _likedPostIds.add(postId);
                                                _likesCount[postId] =
                                                    (_likesCount[postId] ?? 0) +
                                                    1;
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    10,
                                                  ), // 👈 Rounded corners
                                              child: Image.network(
                                                post.mediaUrl!,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const SizedBox.shrink();
                                                    },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isLiked
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () async {
                                            final fullName =
                                                await SessionController()
                                                    .getFullName();
                                            if (fullName == null ||
                                                fullName.trim().isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Please update your profile before liking posts.",
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            if (isLiked) {
                                              await responseApi.unlikePost(
                                                postId,
                                              );
                                              setState(() {
                                                _likedPostIds.remove(postId);
                                                _likesCount[postId] =
                                                    (_likesCount[postId] ?? 1) -
                                                    1;
                                              });
                                            } else {
                                              await responseApi.likePost(
                                                postId,
                                              );
                                              await responseApi.sendNotification(
                                                receiverId: post.userId,
                                                message:
                                                    "$fullName liked your post ${post.postContent} ${post.mediaUrl}",
                                                type: "like",
                                                postId: postId,
                                              );
                                              setState(() {
                                                _likedPostIds.add(postId);
                                                _likesCount[postId] =
                                                    (_likesCount[postId] ?? 0) +
                                                    1;
                                              });
                                            }
                                          },
                                        ),
                                        Text(
                                          '${_likesCount[postId] ?? 0} likes',
                                        ),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.comment_outlined,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (showCommentField) {
                                                _showCommentFieldForPost.remove(
                                                  postId,
                                                );
                                              } else {
                                                _showCommentFieldForPost.add(
                                                  postId,
                                                );
                                              }
                                            });
                                          },
                                        ),
                                        Text('$commentCount comments'),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.share_outlined,
                                          ),
                                          onPressed: () => sharePost(
                                            post.postContent ?? '',
                                            post.mediaUrl,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (showCommentField)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: commentController,
                                              decoration: const InputDecoration(
                                                hintText: "Add a comment...",
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.send),
                                            onPressed: () async {
                                              final commentText =
                                                  commentController.text.trim();
                                              if (commentText.isEmpty) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Please enter a comment",
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              final fullName =
                                                  await SessionController()
                                                      .getFullName();
                                              if (fullName == null ||
                                                  fullName.trim().isEmpty) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Please update your profile before commenting.",
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              await responseApi.postComment(
                                                postId,
                                                commentText,
                                              );
                                              await responseApi.sendNotification(
                                                receiverId: post.userId,
                                                message:
                                                    "$fullName commented on your post ${post.postContent} ${post.mediaUrl} ${commentText}",
                                                type: "comment",
                                                postId: postId,
                                              );

                                              setState(() {
                                                _postNewComments.putIfAbsent(
                                                  postId,
                                                  () => [],
                                                );
                                                _postNewComments[postId]!.add(
                                                  commentText,
                                                );
                                                _showCommentFieldForPost.remove(
                                                  postId,
                                                );
                                                commentController.clear();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
