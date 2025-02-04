class SharedPost {
  final int originalPostId;
  final String originalPostUserName;
  final String originalPostTitle;
  final String originalPostDescription;
  final String originalPostImage;
  final String username;  
  final String comment;   

  SharedPost({
    required this.originalPostId,
    required this.originalPostUserName,
    required this.originalPostTitle,
    required this.originalPostDescription,
    required this.originalPostImage,
    required this.username,
    required this.comment,
  });
}