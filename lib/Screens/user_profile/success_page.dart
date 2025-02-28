import 'package:flutter/material.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';

class SuccessPage extends StatelessWidget {
  final String status;
  final String patientName;
  final int price;
  final int nurseId;
  const SuccessPage({
    super.key,
    required this.nurseId,
    required this.status,
    required this.patientName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NurseProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Updated"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: status == "Completed" ? Colors.green : Colors.red,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Patient: $patientName",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Status: $status",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: status == "Completed" ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              if (status == "Completed")
                Text(
                  "Total Price: \$$price",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  provider.getNursePatients(nurseId);
                  Navigator.pop(context);
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
