import 'package:flutter/material.dart';
import 'package:medimed/Screens/section5_nurseprofile/Request_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RequestsPage(),
    );
  }
}

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  int? selectedIndex;

  final List<Map<String, String>> doctors = [
    {'name': 'Alexander Bennett', 'image': 'assets/doctor1.png'},
    {'name': 'Michael Davidson', 'image': 'assets/doctor2.png'},
    {'name': 'Olivia Turner', 'image': 'assets/doctor3.png'},
    {'name': 'Sophia Martinez', 'image': 'assets/doctor4.png'},
    {'name': 'Alexander Bennett', 'image': 'assets/doctor1.png'},
    {'name': 'Michael Davidson', 'image': 'assets/doctor2.png'},
    {'name': 'Olivia Turner', 'image': 'assets/doctor3.png'},
    {'name': 'Alexander Bennett', 'image': 'assets/doctor1.png'},
    {'name': 'Michael Davidson', 'image': 'assets/doctor2.png'},
    {'name': 'Olivia Turner', 'image': 'assets/doctor3.png'},
    {'name': 'Sophia Martinez', 'image': 'assets/doctor4.png'},
    {'name': 'Alexander Bennett', 'image': 'assets/doctor1.png'},
    {'name': 'Michael Davidson', 'image': 'assets/doctor2.png'},
    {'name': 'Olivia Turner', 'image': 'assets/doctor3.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Requests", style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.blue),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>BookingPage() ,));

                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(15),
                  border: selectedIndex == index ? Border.all(color: Colors.blue, width: 5) : null,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(doctors[index]['image']!),
                  ),
                  title: Text(
                    doctors[index]['name']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.blue), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.blue), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today, color: Colors.blue), label: ''),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }
}
