import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostState();
}

class _AddPostState extends State<AddPostPage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post to"),
        automaticallyImplyLeading: false, 
        actions: [
          TextButton(onPressed: () {}, child: Text("Post",style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),))
        ],
  
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Give a title",
                border: OutlineInputBorder()
        
              ),
              maxLength: 50,
            ),
            SizedBox(height: 20,),
            
        
        
        
        
            
          ],
        ),
      ),
    );
  }
}