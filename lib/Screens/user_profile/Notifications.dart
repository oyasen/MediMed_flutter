import 'package:flutter/material.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  final int? id;

  const NotificationsPage({super.key, required this.id});

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
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Icon(Icons.search, color: Colors.blue),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Consumer<NurseProvider>(
                  builder: (context, value, child) {
                    if (value.nurseModel == null) {
                      value.getNursePatients(id!);
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (value.nurseModel!.Model.isEmpty) {
                      return const Center(child: Text("No notifications available."));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: value.nurseModel!.Model.length,
                      itemBuilder: (context, index) {
                        var nurse = value.nurseModel!.Model[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF66D2FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: nurse['idCard'] != null
                                    ? AssetImage(nurse['idCard']!)
                                    : null,
                              ),
                              title: Text(
                                nurse['fullName'] ?? "Unknown",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
