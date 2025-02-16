import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/patientmodel.dart';
import '../../provider/patientprovider.dart';

class UpdateProfilePage extends StatefulWidget {
  final PatientModel patient;

  const UpdateProfilePage({super.key, required this.patient});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController dobController;

  @override
  void initState() {
    super.initState();

    // Extract data from Model Map
    Map<dynamic, dynamic> data = widget.patient.Model;

    nameController = TextEditingController(text: data['fullName'] ?? '');
    phoneController = TextEditingController(text: data['contact']?.toString() ?? '');
    emailController = TextEditingController(text: data['email'] ?? '');
    dobController = TextEditingController(text: data['dateOfBirth'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Profile', style: TextStyle(color: Color(0xFF00BFFF))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(widget.patient.Model['idCard'] ?? 'https://via.placeholder.com/150'),
                ),
              ),
              SizedBox(height: 20),
              buildTextField("Full Name", nameController),
              buildTextField("Phone Number", phoneController, isNumber: true),
              buildTextField("Email", emailController),
              buildTextField("Date Of Birth", dobController),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await patientProvider.updatePatient(
                      id: widget.patient.Model['id'] ?? 0, // Ensure this exists
                      fullname: nameController.text,
                      url: widget.patient.Model['idCard'] ?? '',
                      email: emailController.text,
                      pass: widget.patient.Model['password'] ?? '',
                      contact: int.tryParse(phoneController.text) ?? 0,
                      date: dobController.text,
                      gender: widget.patient.Model['gender'] ?? 'Other',
                      location: widget.patient.Model['location'] ?? 'Unknown',
                    );
        
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile updated successfully!'))
                    );
        
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00BFFF),
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  ),
                  child: Text('Update Profile', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
