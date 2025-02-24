import 'package:flutter/material.dart';
import 'package:medimed/Screens/user_profile/info_page_nurse.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';

import 'details.dart';

class NotificationsPage extends StatelessWidget {
  final int? id;

  const NotificationsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    var nurseProvider = Provider.of<NurseProvider>(context);
    nurseProvider.getNurseById(nurseProvider.nurseAddModel!.id);
    var nurse = nurseProvider.nurseGetModel;
    if(nurse == null)
    {
      return Scaffold(body: Center(child: CircularProgressIndicator(),));
    }

    if(nurse.Model["approved"] != "Accepted")
    {
      return InfoPageNurse(patient: nurse);
    }
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
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.blue),
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
                child: Consumer<NurseProvider>(
                  builder: (context, value, child) {
                    value.getNursePatients(id!);
                    if (value.patientsModel == null) {

                      return const Center(child: CircularProgressIndicator());
                    }
                    var patients = [];
                    for (var i = 0 ; i < value.patientsModel!.Model.length ; i++)
                      {
                        if(value.patientsModel!.Model[i]["status"] == "Processing")
                          {
                            patients.add(value.patientsModel!.Model[i]);
                          }
                      }
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
                            // Navigate to PatientDetailsPage with parameters
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailsPage(
                                  nurseId: id!,  // Passing nurseId
                                  patientData: patientData, // Passing patient data
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF66D2FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: patientData['idCard'] != null
                                      ? NetworkImage(patientData['idCard']!)
                                      : null,
                                ),
                                title: Text(
                                  patientData['fullName'] ?? "Unknown",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  "Status: ${nurse['status'] ?? 'Unknown'}",
                                  style: const TextStyle(
                                    color: Colors.white,
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
    );
  }
}
