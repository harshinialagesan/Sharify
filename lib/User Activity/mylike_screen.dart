import 'package:flutter/material.dart';
import 'package:my_app/providers/post_providers.dart';
import 'package:provider/provider.dart';

class MyLikeScreen extends StatefulWidget {
  @override
  _MyLikeScreenState createState() => _MyLikeScreenState();
}

class _MyLikeScreenState extends State<MyLikeScreen> {
  final Set<int> _selectedPosts = {};
  @override
  void initState() {
    super.initState();
    Provider.of<PostProvider>(context, listen: false).fetchLikedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Liked Posts'),
        actions: [
          if (_selectedPosts.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _unlikeSelectedPosts(context);
              },
            ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, likedPostsProvider, child) {
          final likedPosts = likedPostsProvider.likedPosts;

          if (likedPosts.isEmpty) {
            return Center(child: Text('No liked posts available.'));
          }

          return ListView.builder(
            itemCount: likedPosts.length,
            itemBuilder: (context, index) {
              final post = likedPosts[index];
              final isSelected = _selectedPosts.contains(post.id);

              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Title
                      Text(post.title, 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),

                      // Description
                      Text(post.description),
                      SizedBox(height: 10),

                      // Tags
                      Wrap(
                        children: post.tags
                            .map((tag) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Chip(label: Text(tag)),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 10),

                      // Images
                      if (post.images.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            post.images[0],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 10),

                      // Checkbox for selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.favorite, color: Colors.red),
                          Checkbox(
                            value: isSelected,
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  _selectedPosts.add(post.id);
                                } else {
                                  _selectedPosts.remove(post.id);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
void _unlikeSelectedPosts(BuildContext context) async {
  final postProvider = Provider.of<PostProvider>(context, listen: false);

  for (int postId in _selectedPosts) {
    await postProvider.toggleLike(postId); 
  }

  _selectedPosts.clear(); 
  await postProvider.fetchLikedPosts();

  if (mounted) {
    setState(() {});
  } 
}

}
