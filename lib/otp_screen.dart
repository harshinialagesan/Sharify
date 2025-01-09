import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/constants.dart';


class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

 @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFF0288D1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
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
            ),
            const Spacer(),
            // OTP Title
            const Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter the OTP sent to your registered email",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // OTP Input Fields
            const OtpTextField(),
            const SizedBox(height: 30),
            // Verify Button
            SizedBox(
              width: width * 0.8,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Action for Verify OTP
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 8, 120, 225),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Verify OTP",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive the OTP? ",
                  style: TextStyle(color: Colors.black54,fontSize: 18,),
                  
                ),
                GestureDetector(
                  onTap: () {
                    // Action for Resend OTP
                  },
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Color.fromARGB(255, 8, 120, 225),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,

                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class OtpTextField extends StatelessWidget {
  const OtpTextField({super.key});
  
  @override
  Widget build(BuildContext context) {
   return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      CustomTextField(),
      CustomTextField(),
      CustomTextField(),
      CustomTextField(),
      CustomTextField(),
      CustomTextField(), 
    ],
   );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});
  
  @override
  Widget build(BuildContext context) {
   return SizedBox(
    height: 50,
    width: 50,
    child: TextFormField(
      onChanged: (value) {
        if(value.length == 1){
          FocusScope.of(context).nextFocus();
        }
      },
      textAlign: TextAlign.center,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    ),
   );
   
  }
}

