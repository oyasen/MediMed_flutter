import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medimed/provider/nurseprovider.dart';

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
    final isCompleted = status == "Completed";
    final provider = Provider.of<NurseProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Status",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success Illustration
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green[50] : Colors.red[50],
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Icon(
                        isCompleted ? Icons.check_circle : Icons.cancel,
                        color: isCompleted ? Colors.green : Colors.red,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Status Title
                    Text(
                      isCompleted ? "Request Accepted!" : "Request Declined",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.green[800] : Colors.red[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Patient Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            patientName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: $status",
                            style: TextStyle(
                              fontSize: 16,
                              color: isCompleted ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isCompleted) ...[
                            const SizedBox(height: 8),
                            Text(
                              "Service Fee: EGP $price",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Additional Message
                    Text(
                      isCompleted
                          ? "You will be notified when the patient confirms."
                          : "The patient has been notified of your decision.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  provider.getNursePatients(nurseId);
                  Navigator.of(context)
                    ..pop()
                    ..pop(); // Return to home screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}