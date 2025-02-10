import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UpdateProfilePage(),
    );
  }
}

class UpdateProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController(text: 'John Doe');
  final TextEditingController phoneController = TextEditingController(text: '+123 567 89000');
  final TextEditingController emailController = TextEditingController(text: 'johndoe@example.com');
  final TextEditingController dobController = TextEditingController(text: 'DD/MM/YYYY');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Profile', style: TextStyle(color: Color(0xFF00BFFF))),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image for profile
              ),
            ),
            SizedBox(height: 20),
            Text('Full Name', style: TextStyle(fontSize: 16)),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text('Phone Number', style: TextStyle(fontSize: 16)),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text('Email', style: TextStyle(fontSize: 16)),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text('Date Of Birth', style: TextStyle(fontSize: 16)),
            TextField(
              controller: dobController,
              decoration: InputDecoration(
                hintText: 'DD/MM/YYYY',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement update logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00BFFF),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
                child: Text('Update Profile', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}