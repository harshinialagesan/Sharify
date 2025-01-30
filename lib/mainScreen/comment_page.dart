// import 'package:flutter/material.dart';
// import 'package:my_app/models/comment_class.dart';
// import 'package:provider/provider.dart';
// import 'package:my_app/providers/comment_providers.dart';

// class CommentScreen extends StatelessWidget {
//   final int postId;

//   CommentScreen({required this.postId});

//   @override
//   Widget build(BuildContext context) {
//     final commentProvider = Provider.of<CommentProvider>(context,listen: false);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       commentProvider.fetchCommentsByPostId(postId); // This call will happen after the current frame build
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Comments'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             // Add a new comment field
//             TextField(
//               decoration: const InputDecoration(
//                 labelText: "Add a Comment",
//                 border: OutlineInputBorder(),
//               ),
//               onSubmitted: (value) {
//                 commentProvider.addComment(postId, value);
//               },
//             ),
//             const SizedBox(height: 10),
//             // Display comments
//             Expanded(
//               child: commentProvider.isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: commentProvider.comments.length,
//                       itemBuilder: (ctx, index) {
//                         final comment = commentProvider.comments[index];

//                         return ListTile(
//                           title: Text(comment.comment),
//                           subtitle: Row(
//                             children: [
//                               Text("By: ${comment.userName}"),
//                               Text(" | Created: ${comment.createdAt}"),
//                               // Show edit and delete buttons only if it's the current user's comment
//                               if (comment.userId == commentProvider.currentUserId)
//                                 IconButton(
//                                   icon: const Icon(Icons.edit),
//                                   onPressed: () {
//                                     _showUpdateDialog(
//                                       context,
//                                       comment,
//                                       commentProvider,
//                                     );
//                                   },
//                                 ),
//                               if (comment.userId == commentProvider.currentUserId)
//                                 IconButton(
//                                   icon: const Icon(Icons.delete),
//                                   onPressed: () {
//                                     commentProvider.deleteComment(postId, comment.commentId);
//                                   },
//                                 ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Show a dialog to update comment
//   void _showUpdateDialog(
//       BuildContext context, Comment comment, CommentProvider commentProvider) {
//     final controller = TextEditingController(text: comment.comment);

//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: const Text('Update Comment'),
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(labelText: "Updated Comment"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Update the comment
//                 commentProvider.updateComment(comment.commentId, controller.text);
//                 Navigator.of(ctx).pop();
//               },
//               child: const Text('Update'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(ctx).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
