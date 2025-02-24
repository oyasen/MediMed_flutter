import 'package:flutter/material.dart';
import 'package:medimed/Screens/HomeScreen/info_page.dart';
import 'package:medimed/Screens/section5_nurseprofile/Requests.dart';
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
    patientProvider.getPatientById(patientProvider.patientAddModel!.id);
    patientProvider.getPatientsNurse(patientProvider.patientAddModel!.id);
    var patient = patientProvider.patientModel;
    if(patient == null)
      {
        return Scaffold(body: Center(child: CircularProgressIndicator(),));
      }

    if(patient.Model["approved"] != "Accepted")
      {
        return InfoPage(patient: patient);
      }
    else
      {
        return Scaffold(
          backgroundColor: Color(0xFFF5F9FF),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisSize: MainAxisSize.min, // Prevents excessive space usage
              children: [
                Consumer<PatientProvider>(
                  builder: (context, provider, child) {
                    return CircleAvatar(
                      backgroundImage: provider.patientModel?.Model["idCard"] != null
                          ? NetworkImage(provider.patientModel!.Model["idCard"])
                          : null,
                      child: provider.patientModel?.Model["idCard"] == null
                          ? Icon(Icons.person, color: Colors.grey)
                          : null,
                    );
                  },
                ),
                SizedBox(width: 10),
                Expanded( // Prevents overflow
                  child: Consumer<PatientProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Welcome Back',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis, // Prevents text overflow
                          ),
                          Text(
                            provider.patientModel?.Model["fullName"] ?? 'User',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis, // Prevents text overflow
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestsPage(patientData: patientProvider.patientAddModel!.id),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        imageUrl: patientProvider.patientModel?.Model["idCard"] ?? '',
                      ),
                    ),
                  );
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
                    CategoryIcon(title: 'Dentistry', imageUrl: 'https://cdn-icons-png.flaticon.com/512/2947/2947853.png'),
                    CategoryIcon(title: 'Cardiology', imageUrl: 'https://cdn-icons-png.flaticon.com/512/2966/2966327.png'),
                    CategoryIcon(title: 'Pulmonary', imageUrl: 'https://cdn-icons-png.flaticon.com/512/1052/1052860.png'),
                    CategoryIcon(title: 'General', imageUrl: 'https://cdn-icons-png.flaticon.com/512/2921/2921822.png'),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Consumer<NurseProvider>(
                    builder: (context, value, child) {
                      if (value.nurseModel == null) {
                        value.getAllNurses();
                        return const Center(child: CircularProgressIndicator());
                      }
                      else {
                        for(var nurse in value.nurseModel!.Model)
                          {
                            if(nurse["approved"] != "Accepted")
                              {
                                value.nurseModel!.Model.remove(nurse);
                              }
                          }
                        return ListView.builder(
                          itemCount: value.nurseModel?.Model.length ?? 0,
                          itemBuilder: (context, index) {
                            var nurse = value.nurseModel?.Model[index]; // Get nurse data

                            return DoctorCard(
                              name: nurse['fullName'] ?? 'Nurse Name',
                              specialty: nurse['specialaization'] ?? 'Specialization',
                              rating: nurse['rating']?.toDouble() ?? 5.0,
                              imageUrl: nurse['idCard'] ?? '',
                              nurseData: nurse,
                              patientData: patientProvider.patientAddModel!.id, // Pass the actual nurse data
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
          backgroundImage: NetworkImage(imageUrl),
          onBackgroundImageError: (_, __) => Icon(Icons.image_not_supported),
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
  final Map<String, dynamic> nurseData;
  final int patientData;

  const DoctorCard({super.key, required this.name, required this.specialty, required this.rating, required this.imageUrl, required this.nurseData, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NurseProfileScreen1(nurseData: nurseData, patientData: patientData,)));
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty ? Icon(Icons.person, color: Colors.grey) : null,
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