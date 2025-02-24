import 'package:flutter/material.dart';
import 'package:medimed/Models/patientmodel.dart';
import 'package:medimed/Screens/user_profile/update_profile.dart';

class InfoPage extends StatelessWidget {
  PatientModel patient;
  InfoPage({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Status"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                patient.Model["approved"] == "Processing"?Icons.build_circle:Icons.cancel,
                color:patient.Model["approved"] == "Processing"?Colors.grey:Colors.red,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Name: ${patient.Model["fullName"]}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Status: ${patient.Model["approved"]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:patient.Model["approved"] == "Processing"?Colors.black:Colors.red ,
                ),
              ),
              if(patient.Model["message"] != "") Text(
                "Message: ${patient.Model["message"]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if(patient.Model["approved"] == "Declined") const SizedBox(height: 30),
              if(patient.Model["approved"] == "Declined") ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfilePage(patient: patient),));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("Update your data", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("Back to Home", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
