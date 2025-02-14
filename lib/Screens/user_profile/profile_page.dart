import 'package:flutter/material.dart';
import 'package:medimed/Screens/section4_payment/page1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage2(),
    );
  }
}

class ProfilePage2 extends StatelessWidget {
  const ProfilePage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Profile', style: TextStyle(color: Color(0xFF00BFFF))),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image for profile
            ),
            SizedBox(height: 20),
            Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            OptionTile(icon: Icons.person, title: 'Profile', onTap: () {

            }),
            OptionTile(icon: Icons.favorite, title: 'Favorite', onTap: () {}),
            OptionTile(icon: Icons.payment, title: 'Payment Method', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage1(),));
            }),
            OptionTile(icon: Icons.settings, title: 'Settings', onTap: () {}),
            SizedBox(height: 20),
            OptionTile(icon: Icons.logout, title: 'Logout', onTap: () {
              // Implement logout functionality
            }),
          ],
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const OptionTile({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF00BFFF)),
            SizedBox(width: 20),
            Text(title, style: TextStyle(fontSize: 18)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}