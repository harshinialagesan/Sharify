import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/models/auth_service_class.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _authService = AuthService();
  late Map<String, dynamic> userData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
      final userId = await _authService.getUserId();


    if (userId != null) {
      final response = await http.get(Uri.parse('http://172.20.1.191:8080/user/get/$userId'));

      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body)['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return const Scaffold(
        body: Center(child: Text('Error loading user details.')),
      );
    }

    String userName = userData['userName'] ?? 'User';
    String userEmail = userData['userEmail'] ?? 'user@example.com';
    int postCount = userData['postCount'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30,),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : "?",
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            
            // Username
            Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 5),
            
            // User Email
            Text(
              userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            const SizedBox(height: 10),
            
            // Post Count
            Text(
              "Posts: $postCount",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
