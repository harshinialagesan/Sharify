class Post {
  final int id;
  final String title;
  final String description;
  final String userName;
  final List<String> tags;
  final List<String> images;
  int likes;
  final int comments;
  final int share;
  final String createdAt;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.userName,
    required this.tags,
    required this.images,
    required this.likes,
    required this.comments,
    required this.share,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userName: json['userName'],
      tags: List<String>.from(json['tags']),
      images: List<String>.from(json['images']),
      likes: json['likes'],
      comments: json['comments'],
      share: json['share'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags,
    };
  }
}



