class Post {
  final String postId;
  final String userId;
  final String profileImage;
  final String fullName;
  final String designation;
  final String postContent;
  final String mediaUrl;
  final int totalLikes;
  late final int totalComments;

  // Local UI state
  bool isLiked;
  bool isFollowed;
  bool isCommented;

  Post({
    required this.postId,
    required this.userId,
    required this.profileImage,
    required this.fullName,
    required this.designation,
    required this.postContent,
    required this.mediaUrl,
    required this.totalLikes,
    required this.totalComments,
    this.isLiked = false,
    this.isFollowed = false,
    this.isCommented = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      profileImage: json['profile_image'] as String,
      fullName: json['full_name'] as String,
      designation: json['designation'] as String,
      postContent: json['post_content'] as String,
      mediaUrl: json['media_url'] as String,
      totalLikes: json['total_likes'] as int,
      totalComments: json['total_comments'] as int,
      // We won't initialize isLiked, isFollowed, isCommented from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'profile_image': profileImage,
      'full_name': fullName,
      'designation': designation,
      'post_content': postContent,
      'media_url': mediaUrl,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      // We exclude isLiked, isFollowed, isCommented from toJson()
    };
  }
}

class PostResponse {
  final List<Post> posts;

  PostResponse({required this.posts});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'posts': posts.map((e) => e.toJson()).toList()};
  }
}
