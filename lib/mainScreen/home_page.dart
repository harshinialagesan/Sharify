import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;


    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, 
          title: Text("Sharify",style: TextStyle(
            color: Colors.black
            
          ),),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text("UserName",style: TextStyle(color: Colors.black),)
                    ],
                  ),
                 ],
              
              ),
              SizedBox(height: 10,),
              Text(
                "Post Title",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 10,),
              Container(
                width:double.infinity ,
                height: height * 0.30,
                color: Colors.cyan,
              ),
               SizedBox(height: 10,),
              Text(
                "Post Description",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 8,),
              Row(
                children: [
                  Icon(Icons.favorite,color: Colors.black,),
                  SizedBox(width: 10,),
                  Icon(Icons.message_outlined,color: Colors.black,),
                  SizedBox(width: 10,),
                  Icon(Icons.send,color: Colors.black,),
                ],
              ),
              Text("View all Comments",style: TextStyle(color: Colors.grey),)
            ],
          ),
        ),


    );
  }
}