  import 'package:flutter/material.dart';
  import 'package:my_app/mainScreen/comment_page.dart';
  import 'package:my_app/mainScreen/comment_screen.dart';
  import 'package:my_app/mainScreen/log_out_page.dart';
import 'package:my_app/mainScreen/mylike_screen.dart';
  import 'package:my_app/mainScreen/mypost_screen.dart';
  import 'package:my_app/providers/post_providers.dart';
  import 'package:provider/provider.dart';

  class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
         postProvider.loadLikedPosts();  // Load liked posts first
         postProvider.fetchPosts(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Sharify", style: TextStyle(color: Colors.black)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
                !postProvider.isLoading &&
                postProvider.hasMorePosts) {
              postProvider.fetchPosts();
            }
            return false;
          },
          child: postProvider.posts.isEmpty && !postProvider.isLoading
              ? const Center(child: Text("No posts available."))
              : ListView.builder(
                  itemCount: postProvider.posts.length +
                      (postProvider.isLoading ? 1 : 0),
                  itemBuilder: (ctx, index) {
                    if (index == postProvider.posts.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final post = postProvider.posts[index];
                    final isLiked = postProvider.isPostLiked(post.id);

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(post.userName),
                            subtitle: Text(post.title),
                          ),
                          if (post.images.isNotEmpty)
                             Image.network(
                              post.images[0],
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; 
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(post.description),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Wrap(
                              children: post.tags
                                  .map((tag) => Chip(label: Text(tag)))
                                  .toList(),
                            ),
                          ),
                          Consumer<PostProvider>(
                            builder: (context, postProvider, child) {
                              final isLiked = postProvider.isPostLiked(post.id);
                              return Row(
                              children: [
                                SizedBox(width: 10,),
                                AnimatedLikeButton(postId: post.id), 


                                Text('${post.likes} Likes'), // Display likes count


                              IconButton(
                                  icon: const Icon(Icons.message_outlined),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,  
                                      elevation: 0,  
                                      builder: (context) {
                                        return Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Container(
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom,
                                              ),
                                              child: DraggableScrollableSheet(
                                                maxChildSize: 1.0,
                                                initialChildSize: 0.5,
                                                minChildSize: 0.2,
                                                builder: (context, scrollController) {
                                                  return Container(
                                                    color: Colors.white,  
                                                    child: CommentScreen(postId: post.id),  
                                                  );
                                                },
                                              ),
                                            ),

                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                Text('${post.comments} Comments '), // Display likes count
                              SizedBox(width: 10,),
                              const Icon(Icons.send),
                            ],
                          );
                            }
                          ),

                          SizedBox(height: 10,),
                              
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
             ListTile(
                title: const Text(
                  "My Activity",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tileColor: Colors.blue[500], 
              ),
           
            ListTile(
              leading: const Icon(Icons.post_add),
              title: const Text("My Posts"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  MyPostScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite,color: Colors.red,),
              title: const Text("My Likes"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  MyLikeScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text("Logout")),
                    body: LogoutTile(),
                  ),
                ),
              );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedLikeButton extends StatefulWidget {
  final int postId;

  AnimatedLikeButton({required this.postId});

  @override
  _AnimatedLikeButtonState createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<AnimatedLikeButton> {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final isLiked = postProvider.isPostLiked(widget.postId);

    return GestureDetector(
      onTap: () {
        postProvider.toggleLike(widget.postId);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isLiked),
          color: isLiked ? Colors.red : Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
