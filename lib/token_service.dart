// import 'package:shared_preferences/shared_preferences.dart';

// class TokenService {
//   static const String _tokenKey = "authToken";

//   // Save token
//   static Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenKey, token);
//   }

//   // Get token
//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenKey);
//   }

//   // Delete token
//   static Future<void> deleteToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_tokenKey);
//   }

//   // Check if token exists
//   static Future<bool> hasToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.containsKey(_tokenKey);
//   }
// }