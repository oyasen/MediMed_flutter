import 'package:flutter/material.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';

class SuccessBookPage extends StatelessWidget {
  final String status;
  final String nurseName;
  const SuccessBookPage({
    super.key,
    required this.status,
    required this.nurseName,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NurseProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booked nurse"),
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
                color:Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Nurse: $nurseName",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Status: $status",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:Colors.green ,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  provider.getAllNurses();
                  Navigator.pop(context);
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
