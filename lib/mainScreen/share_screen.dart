import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/post_providers.dart';

class MySharesScreen extends StatefulWidget {
  @override
  _MySharesScreenState createState() => _MySharesScreenState();
}

class _MySharesScreenState extends State<MySharesScreen> {
  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.fetchSharedPosts();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Shared Posts")),
      body: postProvider.sharedPosts.isEmpty
          ? const Center(child: CircularProgressIndicator())  
          : ListView.builder(
              itemCount: postProvider.sharedPosts.length,
              itemBuilder: (ctx, index) {
                final sharedPost = postProvider.sharedPosts[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(sharedPost.username,textAlign: TextAlign.right,),
                        subtitle: Text(sharedPost.comment,textAlign: TextAlign.right,),
                        
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(sharedPost.originalPostUserName),
                      ),
                      Image.network(sharedPost.originalPostImage),
                      
                      Padding(                                                                                       
                        padding: const EdgeInsets.all(8.0),
                        child: Text(sharedPost.originalPostTitle),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(sharedPost.originalPostDescription),
                      ),

                    ],
                  ),
                );
              },
            ),
    );
  }
}
