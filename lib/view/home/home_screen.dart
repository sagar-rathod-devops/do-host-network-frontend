import 'dart:io';
import 'package:do_host/bloc/post_all_content_get_bloc/post_all_content_get_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/data/response/status.dart';
import 'package:do_host/dependency_injection/locator.dart';
import 'package:do_host/repository/response_api_repository.dart';
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
  late final PostAllContentGetBloc postAllContentGetBloc;

  final Set<String> _likedPostIds = {};
  final Set<String> _showCommentFieldForPost = {};
  final Map<String, TextEditingController> _commentControllers = {};
  final Map<String, int> _likesCount = {};
  final Map<String, List<String>> _postComments = {};
  final responseApi = ResponseApiRepository();

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error sharing post: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    postAllContentGetBloc = PostAllContentGetBloc(
      postAllContentGetApiRepository: getIt(),
    );

    postAllContentGetBloc.stream.listen((state) {
      if (state is PostAllContentGetState &&
          state.postAllContentGetList.status == Status.completed) {
        final posts = state.postAllContentGetList.data?.posts ?? [];
        for (var post in posts) {
          final postId = post.postId;
          if (postId != null) {
            _likesCount.putIfAbsent(postId, () => post.totalLikes ?? 0);
            responseApi.getComments(postId);
          }
        }
      }
    });

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

  @override
  void dispose() {
    postAllContentGetBloc.close();
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => postAllContentGetBloc..add(PostAllContentGetFetch()),
        child: BlocBuilder<PostAllContentGetBloc, PostAllContentGetState>(
          buildWhen: (previous, current) =>
              previous.postAllContentGetList != current.postAllContentGetList,
          builder: (context, state) {
            switch (state.postAllContentGetList.status) {
              case Status.loading:
                return const Center(child: CircularProgressIndicator());

              case Status.error:
                final errorMsg =
                    state.postAllContentGetList.message ??
                    "Something went wrong!";
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Text(errorMsg, textAlign: TextAlign.center),
                    ],
                  ),
                );

              case Status.completed:
                final posts = state.postAllContentGetList.data?.posts ?? [];
                if (posts.isEmpty)
                  return const Center(child: Text("No posts found"));

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final postId = post.postId;
                    if (postId == null) return const SizedBox();

                    final isLiked = _likedPostIds.contains(postId);
                    final showCommentField = _showCommentFieldForPost.contains(
                      postId,
                    );
                    final commentController = _commentControllers.putIfAbsent(
                      postId,
                      () => TextEditingController(),
                    );
                    final commentCount =
                        (_postComments[postId]?.length ?? 0) +
                        (post.totalComments ?? 0);

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      (post.profileImage != null &&
                                          post.profileImage!.isNotEmpty)
                                      ? NetworkImage(post.profileImage!)
                                      : const AssetImage(
                                              'assets/images/app_icon.png',
                                            )
                                            as ImageProvider,
                                  radius: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
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
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Post content
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

                            if (post.mediaUrl != null &&
                                post.mediaUrl!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Image.network(
                                  post.mediaUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Like
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        if (isLiked) {
                                          await responseApi.unlikePost(postId);
                                          setState(() {
                                            _likedPostIds.remove(postId);
                                            _likesCount[postId] =
                                                (_likesCount[postId] ?? 1) - 1;
                                          });
                                        } else {
                                          await responseApi.likePost(postId);
                                          setState(() {
                                            _likedPostIds.add(postId);
                                            _likesCount[postId] =
                                                (_likesCount[postId] ?? 0) + 1;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLiked
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                    Text('${_likesCount[postId] ?? 0} likes'),
                                  ],
                                ),

                                // Comment
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (showCommentField) {
                                        _showCommentFieldForPost.remove(postId);
                                      } else {
                                        _showCommentFieldForPost.add(postId);
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.comment_outlined),
                                ),

                                // Share
                                IconButton(
                                  onPressed: () async {
                                    await sharePost(
                                      post.postContent ?? '',
                                      post.mediaUrl,
                                    );
                                  },
                                  icon: const Icon(Icons.share_outlined),
                                ),
                              ],
                            ),

                            if (commentCount > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '$commentCount comments',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                            if (showCommentField)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        decoration: const InputDecoration(
                                          hintText: "Add a comment...",
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () async {
                                        final comment = commentController.text
                                            .trim();
                                        if (comment.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Comment cannot be empty",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final success = await responseApi
                                            .postComment(postId, comment);
                                        // if (success) {
                                        commentController.clear();
                                        setState(() {
                                          _showCommentFieldForPost.remove(
                                            postId,
                                          );
                                          _postComments.putIfAbsent(
                                            postId,
                                            () => [],
                                          );
                                          _postComments[postId]!.add(comment);
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Comment added successfully",
                                            ),
                                          ),
                                        );
                                      },
                                      // },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
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
