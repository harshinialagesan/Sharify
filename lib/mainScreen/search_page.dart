import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  List<dynamic> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchPosts(""); 
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    try {
      final uri = Uri.parse(
          'http://172.20.1.191:8080/post/search?page_no=0&page_size=5&sort_by=createdAt&title=$query');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _suggestions = responseData['data']['content'];
        });
      } else {
        print('Failed to fetch suggestions: ${response.body}');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  Future<void> _searchPosts(String query) async {
    setState(() {
      _isLoading = true;
    });

    String apiUrl = query.isEmpty
        ? 'http://172.20.1.191:8080/post/search?page_no=0&page_size=20&sort_by=createdAt'
        : 'http://172.20.1.191:8080/post/search?page_no=0&page_size=10&sort_by=createdAt&title=$query';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _searchResults = responseData['data']['content'];
        });
      } else {
        print('Failed to fetch posts: ${response.body}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToPostDetails(Map<String, dynamic> post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailsScreen(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Search", style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      _fetchSuggestions(query);
                    },
                    onSubmitted: (query) {
                      _searchPosts(query);
                      setState(() {
                        _suggestions = [];
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by title or tags',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _searchPosts(""); // Show all posts when cleared
                                setState(() {
                                  _suggestions = [];
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _searchResults.isEmpty
                          ? const Center(child: Text('No results found'))
                          : GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final post = _searchResults[index];
                                return GestureDetector(
                                  onTap: () => _navigateToPostDetails(post),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Post Image
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10)),
                                              image: post['images'].isNotEmpty
                                                  ? DecorationImage(
                                                      image: NetworkImage(post['images'][0]),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                            child: post['images'].isEmpty
                                                ? const Center(
                                                    child: Icon(Icons.image_not_supported,
                                                        color: Colors.grey, size: 40),
                                                  )
                                                : null,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post['title'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 14),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                post['description'] ?? 'No description',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            if (_suggestions.isNotEmpty)
              Positioned(
                top: 60,
                left: 8,
                right: 8,
                child: Card(
                  elevation: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _suggestions.map<Widget>((suggestion) {
                      return ListTile(
                        title: Text(suggestion['title']),
                        subtitle: Text('Tags: ${suggestion['tags'].join(', ')}'),
                        onTap: () {
                          _searchController.text = suggestion['title'];
                          _searchPosts(suggestion['title']);
                          setState(() {
                            _suggestions = [];
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PostDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post['title'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['images'].isNotEmpty)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: post['images'].length,
                  itemBuilder: (context, index) {
                    return Image.network(post['images'][index], fit: BoxFit.cover);
                  },
                ),
              ),
            const SizedBox(height: 10),
            Text(post['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(post['description'] ?? 'No description available', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              children: post['tags'].map<Widget>((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(5)),
                  child: Text(tag, style: const TextStyle(color: Colors.blue)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
