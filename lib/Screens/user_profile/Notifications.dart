import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {'name': 'Alexander Bennett', 'message': 'Accept your request', 'image': 'assets/alexander.png'},
    {'name': 'Michael Davidson', 'message': 'Accept your request', 'image': 'assets/michael.png'},
    {'name': 'Olivia Turner', 'message': 'Accept your request', 'image': 'assets/olivia.png'},
    {'name': 'Sophia Martinez', 'message': 'Delete your request', 'image': 'assets/sophia.png'},
    {'name': 'Alexander Bennett', 'message': 'Accept your request', 'image': 'assets/alexander.png'},
    {'name': 'Michael Davidson', 'message': 'Accept your request', 'image': 'assets/michael.png'},
    {'name': 'Olivia Turner', 'message': 'Delete your request', 'image': 'assets/olivia.png'},
    {'name': 'Alexander Bennett', 'message': 'Accept your request', 'image': 'assets/alexander.png'},
    {'name': 'Michael Davidson', 'message': 'Accept your request', 'image': 'assets/michael.png'},
    {'name': 'Olivia Turner', 'message': 'Accept your request', 'image': 'assets/olivia.png'},
    {'name': 'Sophia Martinez', 'message': 'Delete your request', 'image': 'assets/sophia.png'},
    {'name': 'Alexander Bennett', 'message': 'Accept your request', 'image': 'assets/alexander.png'},
    {'name': 'Michael Davidson', 'message': 'Accept your request', 'image': 'assets/michael.png'},
    {'name': 'Olivia Turner', 'message': 'Delete your request', 'image': 'assets/olivia.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.arrow_back), color: Colors.blue, onPressed: () {
                    Navigator.pop(context);
                  },),
                  Text(
                    'Notifications',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Icon(Icons.search, color: Colors.blue),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF66D2FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(notifications[index]['image']!),
                          ),
                          title: Text(
                            notifications[index]['name']!,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          subtitle: Text(notifications[index]['message']!, style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              color: Color(0xFF66D2FF),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.home, color: Colors.white, size: 30),
                  Icon(Icons.person, color: Colors.white, size: 30),
                  Icon(Icons.calendar_today, color: Colors.white, size: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}