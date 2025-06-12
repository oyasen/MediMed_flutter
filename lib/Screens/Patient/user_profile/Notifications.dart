import 'package:flutter/material.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';
import '../../Nurse/PatientDetailsPage.dart';
import '../../Nurse/info_page_nurse.dart';

class NotificationsPage extends StatelessWidget {
  final int id;

  const NotificationsPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nurseProvider = Provider.of<NurseProvider>(context);
    nurseProvider.getNurseById(id);

    var nurse = nurseProvider.nurseGetModel;
    if (nurse == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (nurse.Model["approved"] != "Accepted") {
      return InfoPageNurse(patient: nurse);
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.white),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<PatientProvider>(
                    builder: (context, value, child) {
                      value.getPatientsNurse(id);
                      if (value.nurseModel == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var patients = value.nurseModel!.Model
                          .where((patient) => patient["status"] == "Completed")
                          .toList();

                      if (patients.isEmpty) {
                        return const Center(child: Text("No notifications available."));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          var nurse = patients[index];
                          var patientData = nurse['patient'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientDetailsPage(
                                    patientNurseData: nurse,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  leading: CircleAvatar(
                                    backgroundImage: patientData['idCard'] != null
                                        ? NetworkImage(patientData['idCard']!)
                                        : null,
                                    radius: 30,
                                  ),
                                  title: Text(
                                    patientData['fullName'] ?? "Unknown",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Status: ${nurse['status'] ?? 'Unknown'}",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                color: const Color(0xFF66D2FF),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Row(
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
      ),
    );
  }
}