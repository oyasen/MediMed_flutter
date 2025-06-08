import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:provider/provider.dart';
import '../../../Models/patientmodel.dart';
import '../../../provider/patientprovider.dart';

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
  late String gender;
  File? idCard;
  File? pfp;
  @override
  void initState() {
    super.initState();

    // Extract data from Model Map
    Map<dynamic, dynamic> data = widget.patient.Model;

    nameController = TextEditingController(text: data['fullName'] ?? '');
    phoneController = TextEditingController(text: data['contact']?.toString() ?? '');
    emailController = TextEditingController(text: data['email'] ?? '');
    dobController = TextEditingController(text: data['dateOfBirth'] ?? '');
    gender = data['gender'];
    final imageprovider = Provider.of<UploadProvider>(context, listen: false);
    imageprovider.networkImageToFile(widget.patient.Model["idCard"]).then((_) {
      setState(() {
        idCard = imageprovider.selectedImage;
      });
    });
    imageprovider.networkImageToFile(widget.patient.Model["personalPicture"]).then((_) {
      setState(() {
        pfp = imageprovider.selectedImage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    var imageprovider = Provider.of<UploadProvider>(context, listen: false);
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Gender", style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            selected: gender == "Male",
                            title: const Text("Male"),
                            value: "Male",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            selected: gender == "Female",
                            title: const Text("Female"),
                            value: "Female",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ID Card", style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            File? selectedImage = await imageprovider.showOptions(context);
                            if (selectedImage != null) {
                              setState(() {
                                idCard = selectedImage;
                              });
                            }
                          },
                          child: Text("Pick Image"),
                        ),
                        Visibility(
                          visible: idCard != null,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    idCard = null;
                                  });
                                },
                                child: const Icon(Icons.delete, color: Colors.red),
                              ),
                              if (idCard != null)
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    child: Image.file(
                                      idCard!,
                                      width: 50, // Adjust size as needed
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Personal Picture", style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            File? selectedImage = await imageprovider.showOptions(context);
                            if (selectedImage != null) {
                              setState(() {
                                pfp = selectedImage;
                              });
                            }
                          },
                          child: Text("Pick Image"),
                        ),
                        Visibility(
                          visible: pfp != null,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    pfp = null;
                                  });
                                },
                                child: const Icon(Icons.delete, color: Colors.red),
                              ),
                              if (pfp != null)
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    child: Image.file(
                                      pfp!,
                                      width: 50, // Adjust size as needed
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (idCard == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                          SnackBar(content: Text(
                              "Please select an ID Card image"))
                      );
                      return;
                    }
                    if (pfp == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                          SnackBar(content: Text(
                              "Please select an Personal Picture image"))
                      );
                      return;
                    }

                    final imageUrl = await imageprovider
                        .uploadImageToCloudinary(idCard);
                    final pfpUrl = await imageprovider
                        .uploadImageToCloudinary(pfp);

                    if (imageUrl == null || pfpUrl  == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(content: Text(
                            "Image upload failed. Try again.")),
                      );
                      return;
                    }
                    await patientProvider.updatePatient(
                      id: widget.patient.Model['id'] ?? 0, // Ensure this exists
                      fullname: nameController.text,
                      date: dobController.text,
                      email: emailController.text,
                      contact: phoneController.text,
                      url: widget.patient.Model['idCard'] ?? '',
                      pass: widget.patient.Model['password'] ?? '',
                      gender: gender,
                      pfp: pfpUrl,
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
