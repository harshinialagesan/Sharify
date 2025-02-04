import 'package:flutter/material.dart';
import 'package:my_app/providers/comment_providers.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final int postId;
  const CommentScreen({super.key, required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final commentProvider =
          Provider.of<CommentProvider>(context, listen: false);
      commentProvider.fetchComments(widget.postId);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels != 0) {
        final commentProvider =
            Provider.of<CommentProvider>(context, listen: false);
        if (commentProvider.hasMore && !commentProvider.isLoading) {
          commentProvider.fetchComments(widget.postId, loadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Text(
                "Comments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
          const Divider(),

          Expanded(
  child: commentProvider.isLoading && commentProvider.comments.isEmpty
      ? const Center(child: CircularProgressIndicator()) // Show loader initially
      : commentProvider.comments.isEmpty
          ? const Center(child: Text("No comments yet.")) // No comments available
          : ListView.builder(
              controller: _scrollController,
              itemCount: commentProvider.comments.length + 
                  (commentProvider.hasMore ? 1 : 0), // Show loader only if more comments exist
              itemBuilder: (context, index) {
                if (index < commentProvider.comments.length) {
                  final comment = commentProvider.comments[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(comment.userName),
                    subtitle: Text(comment.content),
                  );
                } else if (commentProvider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return Container(); 
                }
              },
            ),
          ),


                    const Divider(),

                    // Add Comment Input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: "Add a comment...",
                              ),
                            ),
                          ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final newComment = _commentController.text.trim();
                    if (newComment.isNotEmpty) {
                      commentProvider.addComment(widget.postId, newComment);
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
