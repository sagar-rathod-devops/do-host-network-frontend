class CommentListResponse {
  final List<Comment> comments;

  CommentListResponse({required this.comments});

  factory CommentListResponse.fromJson(Map<String, dynamic> json) {
    var commentsJson = json['comments'] as List<dynamic>;
    List<Comment> commentsList = commentsJson
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();

    return CommentListResponse(comments: commentsList);
  }

  Map<String, dynamic> toJson() {
    return {'comments': comments.map((e) => e.toJson()).toList()};
  }
}

class Comment {
  final String id;
  final String userId;
  final String postId;
  final String comment;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.comment,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      postId: json['post_id'] as String,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
