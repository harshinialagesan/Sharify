import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/login_screen.dart';
import 'package:my_app/otp_screen.dart';
import 'package:my_app/otp_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body:SingleChildScrollView(
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
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email Address",labelStyle: TextStyle(color: Color.fromARGB(255, 13, 14, 15),fontSize: 18),
                          
                        ),
                      ), 
                       
                    ),
                    Padding(
                         padding: const EdgeInsets.only(top: 10.0),
                         child: Center(
                         child: TextButton(
                         onPressed: () {
                          Navigator.push( context,
                          MaterialPageRoute(  builder: (context) => OtpScreen(),
                          ),
                          );
                        },
                          style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 8, 120, 225),
                          padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                           ),
                          ),
                          child: const Text(
                                  "Send OTP",
                                   style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 18,
                                  ),
                          ), ), ),
                    ),
                          const SizedBox(height: 30), 
                          RichText(
                           text: TextSpan(
                           text: "Already have an account? ",
                           style: const TextStyle(
                             color: Colors.black,
                             fontSize: 18,
                        ),
                          children: [
                          TextSpan(
                            text: "Sign In",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 8, 120, 225),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
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
      
    ); 
  }
}