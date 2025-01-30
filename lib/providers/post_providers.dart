import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/models/auth_service_class.dart';
import 'package:my_app/models/post_class.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  bool _hasMorePosts = true;
  int _page = 0;
  final int _pageSize = 10;
  final AuthService _authService = AuthService();
    Map<int, bool> _likedPostStatus = {}; 


  List<int> _likedPostIds = [];

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMorePosts => _hasMorePosts; 
  List<int> get likedPostIds => _likedPostIds;
   
   Future<void> fetchPosts() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final url = 'http://172.20.1.191:8080/post/getAll?page_no=$_page&page_size=$_pageSize&sort_by=createdAt&tags=';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<Post> loadedPosts = [];
        for (var postData in responseData['data']['content']) {
          final newPost = Post.fromJson(postData);
          if (!_posts.any((post) => post.id == newPost.id)) {
            loadedPosts.add(newPost);
          }
        }
        _posts.addAll(loadedPosts);
        if (responseData['data']['lastPage']) {
          _hasMorePosts = false;
        } else {
          _page++;
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      print('Error fetching posts: $error');
    }

    _isLoading = false;
    notifyListeners();
  }
Future<void> toggleLike(int postId) async {
  final userId = await _authService.getUserId();
  final url = 'http://172.20.1.191:8080/likes/post/$postId?userId=$userId';

  try {
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status']['code'] == "1000") {
        bool isLiked = responseData['data'];

        // Update local like status
        _likedPostStatus[postId] = isLiked;

        // Save liked status to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        List<String> likedPosts = prefs.getStringList('likedPosts') ?? [];

        debugPrint("Before Saving: $likedPosts"); // Check current liked posts

        // Add or remove the postId based on the like/unlike action
        if (isLiked) {
          if (!likedPosts.contains(postId.toString())) {
            likedPosts.add(postId.toString());  // Add the post ID to the list
            debugPrint("Post $postId liked, added to saved list.");
          }
        } else {
          likedPosts.remove(postId.toString());  // Remove the post ID from the list
          debugPrint("Post $postId unliked, removed from saved list.");
        }

        // Save updated list to SharedPreferences
        await prefs.setStringList('likedPosts', likedPosts);

        debugPrint("After Saving: $likedPosts"); // Ensure liked posts are saved correctly

        // Update the post like count
        final postIndex = _posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          if (_posts[postIndex].likes == 0 && isLiked) {
            _posts[postIndex].likes = 1;
          } else if (_posts[postIndex].likes > 0) {
            _posts[postIndex].likes += isLiked ? 1 : -1;
          }
        }

        notifyListeners();
      } else {
        print('Failed to toggle like status: ${responseData['message']}');
      }
    } else {
      print('Failed to toggle like: ${response.body}');
    }
  } catch (error) {
    print('Error toggling like: $error');
  }
}

// Check if a post is liked
bool isPostLiked(int postId) {
  return _likedPostStatus[postId] ?? false;
}

  Future<void>  fetchUserPosts() async {
  if (_isLoading) return;
  _isLoading = true;
  notifyListeners();

  _posts = [];
  _page = 0;
  _hasMorePosts = true;

  final userId = await _authService.getUserId(); 
  final url =
      'http://172.20.1.191:8080/user/posts/$userId?page_no=$_page&page_size=$_pageSize&sort_by=createdAt';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<Post> loadedPosts = [];
      for (var postData in responseData['data']['content']) {
        loadedPosts.add(Post.fromJson(postData));
      }
      _posts.addAll(loadedPosts);

      if (responseData['data']['lastPage']) {
        _hasMorePosts = false;
      } else {
        _page++;
      }
    } else {
      print('Failed to fetch user posts: ${response.body}');
    }
  } catch (error) {
    print('Error fetching user posts: $error');
  }

  _isLoading = false;
  notifyListeners();
}


  Future<void> updatePost(
  int postId, {
  required String title,
  required String description,
  required List<String> tags,
}) async {
  final index = _posts.indexWhere((post) => post.id == postId);
  final userId = await _authService.getUserId();

  try {
    if (index != -1) {
      _posts[index] = Post(
        id: postId,
        title: title,
        description: description,
        userName: _posts[index].userName,
        tags: tags,
        images: _posts[index].images,
        likes: _posts[index].likes,
        comments: _posts[index].comments,
        share: _posts[index].share,
        createdAt: _posts[index].createdAt,
      );
      notifyListeners();
    }

    final payload = json.encode({
      'title': title,
      'description': description,
      'userId': userId,
      'tagName': tags,
    });

    final response = await http.patch(
      Uri.parse('http://172.20.1.191:8080/post/update/$postId'),
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    if (response.statusCode != 200) {
      print('Failed to update post: ${response.body}');
    }
  } catch (error) {
    print('Error updating post: $error');
  }
}

Future<void> loadLikedPosts() async {
  final prefs = await SharedPreferences.getInstance();
  final likedPosts = prefs.getStringList('likedPosts') ?? [];
    debugPrint("Loaded liked posts from SharedPreferences: $likedPosts");


  for (var id in likedPosts) {
    _likedPostStatus[int.parse(id)] = true;
  }
  notifyListeners();
}

  List<Post> _likedPosts = [];

  List<Post> get likedPosts => _likedPosts;

Future<void> fetchLikedPosts() async {
    final userId = await _authService.getUserId(); 

    final response = await http.get(
      Uri.parse('http://172.20.1.191:8080/likes/user/$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['posts'];
      _likedPosts = (data as List).map((postJson) => Post.fromJson(postJson)).toList();
      notifyListeners();  
    } else {
      throw Exception('Failed to load liked posts');
    }
  }

Future<void> deletePost(int postId, BuildContext context) async {
  try {
    final userId = await _authService.getUserId();

    final response = await http.delete(
      Uri.parse('http://172.20.1.191:8080/post/delete/$postId?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response Body: ${response.body}');
    print('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        _posts.removeWhere((post) => post.id == postId);
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post deleted successfully')),
        );
        return;
      }

      try {
        final responseBody = json.decode(response.body);
        if (responseBody['status']['code'] == '1000') {
          _posts.removeWhere((post) => post.id == postId);
          notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post deleted successfully')),
          );
        }
      } catch (parseError) {
        print('JSON Parsing Error: $parseError');
        _posts.removeWhere((post) => post.id == postId);
        notifyListeners();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post')),
      );
    }
  } catch (error) {
    print('Error deleting post: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred while deleting the post')),
    );
  }
}

}



