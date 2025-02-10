import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool generalNotification = true;
  bool sound = true;
  bool payments = false;
  bool cashback = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Notification Setting",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: buildSwitchTile("General Notification", generalNotification, (value) {
                setState(() {
                  generalNotification = value;
                });
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: buildSwitchTile("Sound", sound, (value) {
                setState(() {
                  sound = value;
                });
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: buildSwitchTile("Payments", payments, (value) {
                setState(() {
                  payments = value;
                });
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: buildSwitchTile("Cashback", cashback, (value) {
                setState(() {
                  cashback = value;
                });
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 18)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }
}