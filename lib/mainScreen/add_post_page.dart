import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadPost() async {
  if (_selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select an image.')),
    );
    return;
  }

  if (!_selectedImage!.path.toLowerCase().endsWith('.jpg') && 
      !_selectedImage!.path.toLowerCase().endsWith('.jpeg')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Only JPEG images are allowed.')),
    );
    return;
  }

  final fileSize = await _selectedImage!.length();
  if (fileSize > 5 * 1024 * 1024) { 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image size must be less than 5MB.')),
    );
    return;
  }

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    final userId = prefs.getInt("user_id");

    if (token == null || userId == null) {
      throw Exception("User is not authenticated.");
    }

    final uri = Uri.parse(
      'http://172.20.1.191:8080/post/createPost?title=${Uri.encodeQueryComponent(_titleController.text.trim())}&description=${Uri.encodeQueryComponent(_descriptionController.text.trim())}&userId=$userId&tags=${Uri.encodeQueryComponent(_tagsController.text.trim())}');

    final request = http.MultipartRequest('POST', uri);

    final imageFile = await http.MultipartFile.fromPath(
      'images', 
      _selectedImage!.path,
      contentType: MediaType('image', 'jpeg'), 
    );

    request.files.add(imageFile);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post uploaded successfully!')),
      );
      _clearForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload post. Status code: ${response.statusCode}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _tagsController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,  
                onChanged: (value) {
                  if (value.length > 50) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Title should be a maximum of 50 characters.')),
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,  
                onChanged: (value) {
                  if (value.length > 100) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Description should be a maximum of 100 characters.')),
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (comma-separated),eg:#tag1,..',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text('Select Image'),
                  ),
                  SizedBox(width: 16.0),
                  if (_selectedImage != null) 
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _uploadPost,
                child: Text('Upload Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
