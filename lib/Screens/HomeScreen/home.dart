import 'package:flutter/material.dart';
import 'package:medimed/Screens/section5_nurseprofile/nurser_profile.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';
import '../user_profile/my_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var patientProvider = Provider.of<PatientProvider>(context);
    if(patientProvider.patientModel == null)
    {
      patientProvider.getPatientById(patientProvider.patientAddModel!.id);
    }
    return Scaffold(
      backgroundColor: Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(patientProvider.patientModel?.Model["idCard"]), // Placeholder for profile image
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi, Welcome Back', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(patientProvider.patientModel?.Model["fullName"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings), // Placeholder for settings icon
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                CategoryIcon(title: 'Dentistry', imageUrl: 'https://via.placeholder.com/50' ,),
                CategoryIcon(title: 'Cardiology', imageUrl: 'https://via.placeholder.com/50'),
                CategoryIcon(title: 'Pulmonary', imageUrl: 'https://via.placeholder.com/50'),
                CategoryIcon(title: 'General', imageUrl: 'https://via.placeholder.com/50'),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<NurseProvider>(
                builder: (context, value, child) {
                  if (value.nurseModel == null) {
                    value.getAllNurses();
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else {
                    return
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              DoctorCard(
                                name: '${value.nurseModel?.Model[index]['fullName']}',
                                specialty: '${value.nurseModel?.Model[index]['specialization']}',
                                rating: 5.0,
                                imageUrl: '${value.nurseModel?.Model[index]['idCard']}',
                              ),
                            ],
                          );
                        },
                      );
                  }
                },
            ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF0299C6),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String title;
  final String imageUrl;

  const CategoryIcon({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imageUrl), // Placeholder for category image
        ),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;

  const DoctorCard({super.key, required this.name, required this.specialty, required this.rating, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder:(context) => NurseProfileScreen1(), ));
        },
        child: ListTile(
          leading: CircleAvatar(
          ),
          title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle: Text(specialty, style: TextStyle(color: Colors.grey)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 18),
              Text(rating.toString(), style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}