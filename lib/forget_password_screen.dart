import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/login_screen.dart';
import 'package:my_app/otp_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgetPasswordScreen extends StatefulWidget {
  
  const ForgetPasswordScreen({super.key});

   @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
    bool _isLoading = false;
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();

    Future<void> _ForgetPassScreen() async {
      const String apiUrl = "http://172.20.1.191:8080/user/send-otp";
      final email = _emailController.text;

       setState(() {
      _isLoading = true;
    });

     try{

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

        setState(() {
        _isLoading = false;
      });
     if (response.statusCode == 200) {
    final responseData = json.decode(response.body);

    if (responseData['status']['code'] == "1000") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['data'] ?? "OTP Sent Successfully"),
        backgroundColor: Colors.green,
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['status']['description'] ?? "Unexpected error occurred"),
        backgroundColor: Colors.red,
      ));
    }
  } else {
    final errorData = json.decode(response.body);

    if (errorData['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorData['message'] ?? "User not found with this email"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An unexpected error occurred."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} catch (e) {
  setState(() {
    _isLoading = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Error occurred while sending OTP. Please try again."),
      backgroundColor: Colors.red,
    ),
  );
}
    }


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
                  Image.asset(forgetPasswordImage,
              height: height,
              width: width,
              fit: BoxFit.cover
              ),
              Positioned(
                    top: 40, 
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                    ),
                  ),
          
              Container(
                height: height * 0.50,
                width: width,
                child: Center(
                child: Column(
                  mainAxisSize:MainAxisSize.min ,
                  children: [
                    Text("Forget Password",style: TextStyle(
                      fontSize: 25,fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 15), // 
                      Text(
                       "Enter your email to receive the OTP to reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 25, 112, 242),
                        ),),
                  ],
                ),),
              ),
             
              Container(
                height: height,
                width: width,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40,left: 20,right: 20,bottom: 30),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: "Email Address",labelStyle: TextStyle(color: Color.fromARGB(255, 13, 14, 15),fontSize: 18),
                            
                          ), 
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return "Email is required";
                            }
                            final emailRegEx = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if(!emailRegEx.hasMatch(value)){
                              return "Enter a valid email address";
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
                            :TextButton(
                           onPressed: () {
                            
                              if(_formKey.currentState!.validate()){
                                _ForgetPassScreen();
                              }
                             
                          },
                            style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 8, 120, 225),
                            padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 15),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                             ),
                            ),
                            child: Text(
                                    "Send OTP",
                                     style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 18,
                                    ),
                            ), ), ),
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
              
            ],
            ),
            ],
          ),
        ),
        
      ),
      
    ); 
  }
  

}

 
