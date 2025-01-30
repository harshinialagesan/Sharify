import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/models/auth_service_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Comment {
  final int id;
  final String userName;
  final String content;

  Comment({required this.id, required this.userName, required this.content});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['commentId'],
      userName: json['userName'],
      content: json['comment'],
    );
  }
}

class CommentProvider with ChangeNotifier {
  List<Comment> _comments = [];
  bool _isLoading = false;
  bool _hasMore = true; // To track if more pages are available
  int _currentPage = 0;
  final int _pageSize = 10;
  final AuthService _authService = AuthService();

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchComments(int postId, {bool loadMore = false}) async {
  if (_isLoading) return; // Prevent multiple simultaneous fetches

  _isLoading = true;
  notifyListeners();

  // If it's not a load more request, reset current page and comments list
  if (!loadMore) {
    _currentPage = 0;
    _comments.clear();
    _hasMore = true;
  }

  final url = Uri.parse(
      'http://172.20.1.191:8080/comment/post/$postId?page_no=$_currentPage&page_size=$_pageSize&sort_by=createdAt');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final List<dynamic> newComments = data['comments'];

      if (newComments.isEmpty) {
        _hasMore = false; // No more data to load
      } else {
        _currentPage++; // Increment the page count
        _comments.addAll(newComments.map((c) => Comment.fromJson(c)).toList());
      }
    } else {
      debugPrint("Failed to fetch comments: ${response.body}");
    }
  } catch (error) {
    debugPrint("Error fetching comments: $error");
  } finally {
    _isLoading = false; // Ensure loading state is updated
    notifyListeners();  // Notify UI of state change
  }
}


  Future<void> addComment(int postId, String content) async {
    final userId = await _authService.getUserId();
    if (userId == null) {
      debugPrint("User ID not found in SharedPreferences.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('username');
    if (userName == null) {
      debugPrint("Username not found in SharedPreferences.");
      return;
    }

    final url = Uri.parse('http://172.20.1.191:8080/comment/posts/$postId');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'comment': content}),
      );
      if (response.statusCode == 200) {
        final newComment = Comment(
          id: DateTime.now().millisecondsSinceEpoch,
          userName: userName,
          content: content,
        );
        _comments.insert(0, newComment);
        notifyListeners();
      } else {
        debugPrint("Failed to add comment: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error adding comment: $error");
    }
  }
}
