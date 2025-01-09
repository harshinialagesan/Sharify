import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/login_screen.dart';
import 'package:my_app/sign_up_screen.dart';

void main(){
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);
    
      @override
      Widget build(BuildContext context) {
        return  MaterialApp(
            home: LoginScreen(),
            title: appName,
            debugShowCheckedModeBanner: false,
            
        );
    }
    
}

class HomePage extends StatefulWidget{

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.lightGreen,
        appBar:new AppBar(
            backgroundColor: const Color.fromARGB(255, 74, 173, 195),
            title: new Text("Hello Welcome"),
            centerTitle: true,
            actions: [
                IconButton(
                     icon: Icon(Icons.comment),
                     onPressed: () {},
                     tooltip: "comment icon",

                ) 
            ],
        ),

        body: Center(child: Text("This is first project"),),
        drawer: Drawer(
            child: ListView(
                children: [
                    SizedBox(
                        height: 150,

                    child: DrawerHeader(
                        decoration: BoxDecoration(
                        color: Colors.amber,   
                        ),
                        child: Text(
                            "side menu",
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 23,
                            ),
                            ),
                    ),
                    ),
                    ListTile(
                        title: Text("My like"),   
                        onTap: (){
                            Navigator.pop(context );
                        },
                    ),
                     ListTile(
                        title: Text("My post"),   
                    ),
                    Divider(
                        height: 4.2,
                        thickness: 1,
                        color: Colors.blue,
                    ),
                      ListTile(
                        title: Text("My share"),   
                    ),
                ],
            ),

        ),
    );
  }

}