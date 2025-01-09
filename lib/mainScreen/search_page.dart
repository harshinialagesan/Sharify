import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});


 @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

    final _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:AppBar(
        automaticallyImplyLeading: false, 
          title: Text("Search",style: TextStyle(
            color: Colors.black
          ),),
       ),

       body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                controller: _searchController,
                onChanged: (query) {
                  // Handle search logic here, e.g., filter posts based on query
                },
                decoration: InputDecoration(
                  labelText: 'Search by title or tags',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
                SizedBox(height: 10,),
                GridView.builder(itemCount: 10,physics: ScrollPhysics(),shrinkWrap:true, gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 5), itemBuilder: (context,int index){
                     return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                     );
                }
                ),
                
              ],
            ),
          ),
        ),
      );
  }
}
  

  
 