import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'success_page.dart';

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
  final TextEditingController _notesController = TextEditingController();
  final String _status = "Pending";
  bool _isLoading = false;

  Future<void> _updateStatus(String newStatus) async {
    if (newStatus != "Declined" && _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid price!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      int price = newStatus == "Declined" ? 0 : int.parse(_priceController.text);

      await Provider.of<NurseProvider>(context, listen: false).updateNursePatient(
        nurseId: widget.nurseId,
        patientId: widget.patientData['id'],
        price: price,
        status: newStatus,
      );

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
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Request Details",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Patient Information
            _buildSectionHeader("Patient Information"),
            _buildDetailRow("Full Name", widget.patientData['fullName'] ?? "Unknown"),
            _buildDetailRow("Age", widget.patientData['age']?.toString() ?? "Not specified"),
            _buildDetailRow("Gender", widget.patientData['gender'] ?? "Not specified"),
            const SizedBox(height: 20),

            // Section 2: Medical Details
            _buildSectionHeader("Medical Details"),
            _buildDetailRow("Medical Condition",
                widget.patientData['medicalCondition'] ?? "Not specified"),
            _buildDetailRow("Severity",
                widget.patientData['severity'] ?? "Moderate"),
            const SizedBox(height: 20),

            // Section 3: ID Card
            _buildSectionHeader("Patient ID"),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.patientData['idCard'] != null
                  ? Image.network(widget.patientData['idCard'], fit: BoxFit.cover)
                  : const Center(child: Text("No ID uploaded")),
            ),
            const SizedBox(height: 20),

            // Section 4: Service Details
            _buildSectionHeader("Service Pricing"),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Service Fee (EGP)",
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Additional Notes (Optional)",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                // Decline Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => _updateStatus("Declined"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Decline Request",
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Accept Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _updateStatus("Completed"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Accept Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}