import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'success_page.dart'; // Import SuccessPage

class PatientDetailsPage extends StatefulWidget {
  final int nurseId;
  final Map<String, dynamic> patientData;

  const PatientDetailsPage({
    super.key,
    required this.nurseId,
    required this.patientData,
  });

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  final TextEditingController _priceController = TextEditingController();
  String _status = "processing";

  void _updateStatus(String newStatus) {
    int price = newStatus == "Declined" ? 0 : int.tryParse(_priceController.text) ?? 0;

    Provider.of<NurseProvider>(context, listen: false)
        .updateNursePatient(
        nurseId: widget.nurseId,
        patientId: widget.patientData['id'],
        price: price,
        status: newStatus)
        .then((_) {
      setState(() {
        _status = newStatus;
      });

      // Navigate to Success Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(
            nurseId: widget.nurseId,
            status: newStatus,
            patientName: widget.patientData['fullName'] ?? "Unknown",
            price: price,
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update status: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Details"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Full Name: ${widget.patientData['fullName'] ?? 'Unknown'}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Status: $_status",
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Price",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: widget.patientData['idCard'] != null
                    ? Image.network(
                  widget.patientData['idCard'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  "assets/images/default_patient.png",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus("Completed"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Completed", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus("Declined"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Declined", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
