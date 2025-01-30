import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/login_screen.dart';
import 'package:my_app/mainScreen/home_page.dart';
import 'package:my_app/models/auth_service_class.dart';
import 'package:my_app/providers/comment_providers.dart';
import 'package:my_app/providers/post_providers.dart';
import 'package:my_app/sign_up_screen.dart';
import 'package:provider/provider.dart';

void main(){
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);
    
      @override
      Widget build(BuildContext context) {
        return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostProvider()),  
        ChangeNotifierProvider(create: (context) => CommentProvider()),  
        Provider(create: (context) => AuthService()),  
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
         initialRoute: '/login', 
        routes: {
          '/login': (context) => LoginScreen(), 
          '/home': (context) => HomeScreen(), 
        },
      ),
    );
    }
    
}
