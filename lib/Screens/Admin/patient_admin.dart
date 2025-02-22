import 'package:flutter/material.dart';
import 'package:medimed/Screens/Admin/patient_details.dart';
import 'package:provider/provider.dart';
import '../../provider/adminprovider.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  bool isNursesSelected = false;

  @override
  Widget build(BuildContext context) {
    var adminprovider = Provider.of<Adminprovider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Patients",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<Adminprovider>(
              builder: (context, value, child) {
                var nurses = adminprovider.patientsModel;
                if (nurses == null) {
                  adminprovider.getAllPatients();
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: nurses.Model.length,
                  itemBuilder: (context, index) {
                    return NurseCard(nurse: nurses.Model[index], index: index,);
                  },
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}

class NurseCard extends StatelessWidget {
  final Map nurse;
  final int index;

  const NurseCard({super.key, required this.nurse, required this.index});

  @override
  Widget build(BuildContext context) {
    var adminProv = Provider.of<Adminprovider>(context, listen: false);
    Color statusColor;
    String statusText = nurse["approved"] == "Processing"
        ? "New User"
        : nurse["approved"] == "Accepted"
        ? "Done"
        : "Rejected";

    if (statusText == "New User") {
      statusColor = Colors.green;
    } else if (statusText == "Done") {
      statusColor = Colors.grey;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      color: Colors.blue[100],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(nurse["idCard"]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "name : ${nurse["fullName"]}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text("email : ${nurse["email"]}", style: TextStyle(color: Colors.black)),
                      Text("ph : ${nurse["contact"]}", style: TextStyle(color: Colors.black)),
                      Text("msg : ${nurse["message"]}", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: 75,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      statusText,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetails(patient: adminProv.patientsModel!.Model[index]),
                  ),
                );

                if (result == true) { // If update happened
                  adminProv.getAllPatients(); // Refresh nurse list
                }
              },

              child: Text("Details", style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}


class PatientCard extends StatelessWidget {
  final Map patient;

  const PatientCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[100],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(patient["idCard"]),
        ),
        title: Text("Name: ${patient["fullName"]}"),
        subtitle: Text("Email: ${patient["email"]}"),
      ),
    );
  }
}