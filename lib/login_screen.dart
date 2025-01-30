
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/forget_password_screen.dart';
import 'package:my_app/main_screen.dart';
import 'package:my_app/sign_up_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _loginUser() async {
    const String apiUrl = "http://172.20.1.191:8080/user/login";
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status']['code'] == "1000") {
          final token = responseData['data']['token'];
          final userId = responseData['data']['userId'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth_token", token);
          await prefs.setInt("user_id", userId);
          print(userId);


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          _showErrorDialog(responseData['data']['message'] ?? "Login failed.");
        }
      } else {
        final errorData = json.decode(response.body);
        _showErrorDialog(errorData['data'] ?? "An unexpected error occurred.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Invalid User,Create an Account");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/loginimage.jpg', 
                      height: height * 0.25,
                      width: width,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: height * 0.25,
                      width: width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    appName,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                  ),
                ),
                const Center(
                  child: Text(
                    slogan,
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 73, 162, 210),
                          Color.fromARGB(255, 74, 151, 224).withOpacity(0.01)
                        ],
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 8, 120, 225), fontSize: 18),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      final emailRegEx = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegEx.hasMatch(value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 8, 120, 225), fontSize: 18),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Password must contain at least one uppercase letter.";
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return "Password must contain at least one digit.";
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return "Password must contain at least one special character.";
                    }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, right: 5.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 8, 120, 225),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _loginUser();
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 8, 120, 225),
                              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an Account? ",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                            color: Color.fromARGB(255, 8, 120, 225),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
