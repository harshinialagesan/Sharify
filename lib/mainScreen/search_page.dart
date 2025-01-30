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

  // Fetch suggestions based on the query
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
          _suggestions = responseData['data']['content']; // Contains title and tags
        });
      } else {
        print('Failed to fetch suggestions: ${response.body}');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  // Fetch posts based on the query
  Future<void> _searchPosts(String query) async {
    setState(() {
      _isLoading = true;
    });

    final uri = Uri.parse(
        'http://172.20.1.191:8080/post/search?page_no=0&page_size=10&sort_by=createdAt&title=$query');
    try {
      final response = await http.get(uri);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
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
              decoration: const InputDecoration(
                labelText: 'Search by title or tags',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            if (_suggestions.isNotEmpty)
              Container(
                color: Colors.white,
                height: 200, 
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    final title = suggestion['title'];
                    final tags = suggestion['tags'].join(', ');

                    return ListTile(
                      title: Text(title),
                      subtitle: Text('Tags: $tags'),
                      onTap: () {
                        _searchController.text = title;
                        _searchPosts(title);
                        setState(() {
                          _suggestions = [];
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_searchResults.isEmpty)
              const Center(child: Text('No results found'))
            else
              Expanded(
                child: GridView.builder(
                  itemCount: _searchResults.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final post = _searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        // Handle navigation to post details or other actions
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          image: post['images'].isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(post['images'][0]),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: post['images'].isEmpty
                            ? const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
