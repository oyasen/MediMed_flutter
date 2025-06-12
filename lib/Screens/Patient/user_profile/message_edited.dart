import 'package:flutter/material.dart';

import '../HomeScreen/home.dart';

class MessagesScreen extends StatelessWidget {
  final List<Message> messages = [
    Message(sender: 'Dr. Sarah', content: 'Your test results are ready.', time: '10:45 AM'),
    Message(sender: 'Reception', content: 'Your appointment has been confirmed.', time: 'Yesterday'),
    Message(sender: 'Nurse John', content: 'Please update your profile.', time: '2 days ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Messages', style: TextStyle(color: Colors.black)),
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
          onPressed: () => Navigator.push(context , MaterialPageRoute(builder: (context) => Placeholder(),)),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: messages.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final msg = messages[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFDBEAFE),
                child: Text(
                  msg.sender[0],
                  style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(msg.sender, style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(msg.content, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Text(
                msg.time,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                // Navigate to message detail screen
              },
            ),
          );
        },
      ),
    );
  }
}

class Message {
  final String sender;
  final String content;
  final String time;

  Message({required this.sender, required this.content, required this.time});
}