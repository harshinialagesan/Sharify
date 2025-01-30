class CommentModel {
  final int commentId;
  final int userId;
  final int postId;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final int isActive;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.postId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  CommentModel copyWith({
    int? commentId,
    int? userId,
    int? postId,
    String? comment,
    String? createdAt,
    String? updatedAt,
    int? isActive,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}


