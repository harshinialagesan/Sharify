import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/mainScreen/add_post_page.dart';
import 'package:my_app/mainScreen/home_page.dart';
import 'package:my_app/mainScreen/search_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
   
}

class _MainScreenState extends State<MainScreen> {

   int _currentIndex = 0; 

  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
 
  navigationTapped(int index){
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: const Color.fromARGB(255, 8, 120, 225),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color:Colors.white),label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle,color:Colors.white),label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search,color:Colors.white),label: ""),


          
        

        ],
        onTap: navigationTapped,
      ),

      body: PageView(
        controller:  pageController,
        onPageChanged: onPageChanged,
        children: [
          HomeScreen(),
          AddPostPage(),
          SearchScreen(),
        ],
      ),
    );
  }
}