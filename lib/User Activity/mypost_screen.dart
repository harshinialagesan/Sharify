import 'package:flutter/material.dart';
import 'package:my_app/providers/post_providers.dart';
import 'package:provider/provider.dart';
import 'package:my_app/models/post_class.dart';

class MyPostScreen extends StatefulWidget {
  @override
  _MyPostScreenState createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  bool _showButtons = false;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchUserPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
      ),
      body: postProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : postProvider.posts.isEmpty
              ? Center(child: Text('No posts found.'))
              : Consumer<PostProvider>(
                  builder: (ctx, postProvider, child) {
                    return ListView.builder(
                      itemCount: postProvider.posts.length,
                      itemBuilder: (ctx, index) {
                        final post = postProvider.posts[index];
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(post.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post.description),
                                    Wrap(
                                      spacing: 6.0,
                                      runSpacing: 6.0,
                                      children: post.tags.map((tag) {
                                        return Chip(label: Text(tag));
                                      }).toList(),
                                    ),
                                    if (post.images.isNotEmpty)
                                      Image.network(post.images[0]),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                      _showButtons ? Icons.toggle_on : Icons.toggle_off,
                                      size: 60, 
                                      color: Colors.purple, 
                                    ),                                    
                                    onPressed: () {
                                      setState(() {
                                        _showButtons = !_showButtons;
                                      });
                                    },
                                  ),
                                  if(_showButtons) ...[
                                  Tooltip(
                                    message: "Edit Post",
                                    child: IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () =>
                                          _showEditPostDialog(context, post),
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Delete Post",
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () =>
                                          _showDeleteConfirmationDialog(context, post),
                                    ),
                                  ),
                                ],
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  void _showEditPostDialog(BuildContext context, Post post) {
    final titleController = TextEditingController(text: post.title);
    final descriptionController = TextEditingController(text: post.description);
    final tagsController = TextEditingController(text: post.tags.join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags',
                  hintText: 'Comma-separated tags',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<PostProvider>(context, listen: false).updatePost(
                post.id,
                title: titleController.text,
                description: descriptionController.text,
                tags: tagsController.text.split(',').map((tag) => tag.trim()).toList(),
              );
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
void _showDeleteConfirmationDialog(BuildContext context, Post post) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete Post'),
      content: Text('Are you sure you want to delete this post?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await Provider.of<PostProvider>(context, listen: false)
                .deletePost(post.id, context);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Delete'),
        ),
      ],
    ),
  );
}

}
