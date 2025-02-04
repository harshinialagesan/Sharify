import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});


  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUpUser() async {
    const String apiUrl = "http://172.20.1.191:8080/user/create";
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final userName = _userNameController.text;

    setState(() {
      _isLoading = true;
    });

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"userName":userName,"email": email, "password": password,"confirmPassword": confirmPassword}),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status']['code'] == "1000") {
           SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', userName);
          _showSuccessDialog(responseData['data']);
        } else {
          _showErrorDialog(responseData['data'] ?? "Registration failed.");
        }
      } else {
        final errorData = json.decode(response.body);
        _showErrorDialog(errorData['data'] ?? "An unexpected error occurred.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Error occurred while registering. Please try again.");
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
        body:SingleChildScrollView(
          child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
               children: [
                  Image.asset(bgImage,
              height: height * 0.25,
              width: width,
              fit: BoxFit.cover
              ),
              Container(
                height: height * 0.25,
                width: width,
                decoration: BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ Colors.transparent,Colors.white])),
              ), 
              ],
              ),
              Center(
              child: Text(appName,style: TextStyle(
                fontSize: 23,fontWeight: FontWeight.w600
              ),),),
              Center(
              child: Text(slogan,style: TextStyle(
                color: Colors.blueGrey
              ),),),
               
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:[
                        const Color.fromARGB(255, 73, 162, 210),const Color.fromARGB(255, 74, 151, 224).withOpacity(0.01)
                      ],),
                
                  ),
                  child: Text(" Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22), ),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "UserName",labelStyle: TextStyle(color: Color.fromARGB(255, 8, 120, 225),fontSize: 18),
                    
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email Address",labelStyle: TextStyle(color: Color.fromARGB(255, 8, 120, 225),fontSize: 18),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Email is required";
                    }
                    final emailRegEx =  RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if(!emailRegEx.hasMatch(value)){
                    return "Enter a valid email address";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_open),
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
                    labelText: "Password",labelStyle: TextStyle(color: Color.fromARGB(255, 8, 120, 225),fontSize: 18),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Password is required";
                    }
                    if(value.length < 8){
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
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_open),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    labelText: "Confirm Password",labelStyle: TextStyle(color: Color.fromARGB(255, 8, 120, 225),fontSize: 18),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Password is required";
                    }
                    if(value.length < 8){
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
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: _isLoading
                        ? const CircularProgressIndicator()
                        :  TextButton(
                    onPressed: () {
                        if(_formKey.currentState!.validate()){
                        _signUpUser();
                      }
                      print("Sign Up Pressed");                                 
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 8, 120, 225),
                      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Sign Up" ,
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
              Text(
                "Already have an Account? ",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              TextButton(
                onPressed: () {
                 Navigator.push( context,
                 MaterialPageRoute(  builder: (context) => LoginScreen(), ),
                );
                },
                child: Text(
                  "Sign In",
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

