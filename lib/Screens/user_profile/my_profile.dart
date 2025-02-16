import 'package:flutter/material.dart';
import 'package:medimed/Screens/Buttons.dart';
import 'package:provider/provider.dart';
import 'package:medimed/Screens/user_profile/setting.dart';
import 'package:medimed/Screens/user_profile/update_profile.dart';
import '../../provider/patientprovider.dart';
import '../section4_payment/page2.dart';

class ProfilePage extends StatelessWidget {
  final String imageUrl;

  const ProfilePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: patientProvider.getAllPatient(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final patient = patientProvider.patientModel;
          if (patient == null) {
            return Center(child: Text("Failed to load patient data"));
          }

          Map<dynamic, dynamic> data = patient.Model;
          String name = data['fullName'] ?? 'Unknown';

          return Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child: imageUrl.isEmpty ? Icon(Icons.person, size: 50, color: Colors.grey) : null,
                    ),
                    SizedBox(height: 5),
                    Text(
                      name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    buildMenuItem(Icons.person, "Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfilePage(patient: patient)),
                      );
                    }),
                    buildMenuItem(Icons.payment, "Payment Method", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentPage2()),
                      );
                    }),
                    buildMenuItem(Icons.settings, "Settings", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    }),
                    buildMenuItem(Icons.logout, "Logout", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ButtonPage(),));
                    }),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Are you sure you want to log out?"),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade100,
                          ),
                          onPressed: () {},
                          child: Text("Cancel", style: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {},
                          child: Text("Yes, Logout", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
