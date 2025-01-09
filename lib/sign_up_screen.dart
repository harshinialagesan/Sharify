import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                child: TextButton(
                  onPressed: () {
                      if(_formKey.currentState!.validate()){
                      print("Email: ${_emailController.text}");
                      print("Password: ${_passwordController.text}");
                      print("ConfirmPassword: ${_confirmPasswordController.text}");
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
    );
  }
 }

