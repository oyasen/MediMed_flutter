import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medimed/Models/nursesmodel.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';

class UpdateNurseProfile extends StatefulWidget {
  final Nursegetmodel patient;

  const UpdateNurseProfile({super.key, required this.patient});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateNurseProfile> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController passController;
  late String gender;
  File? idCard;
  File? prof;
  File? grad;
  File? crim;
  File? pfp;
  File? idCardOld;
  File? profOld;
  File? gradOld;
  File? crimOld;
  File? pfpOld;
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
        idCardOld = imageprovider.selectedImage;
      });
    });
    imageprovider.networkImageToFile(widget.patient.Model["personalPicture"]).then((_) {
      setState(() {
        pfp = imageprovider.selectedImage;
        pfpOld = imageprovider.selectedImage;
      });
    });
    imageprovider.networkImageToFile(widget.patient.Model['professionalPracticeLicense']).then((_) {
      setState(() {
        prof = imageprovider.selectedImage;
        profOld = imageprovider.selectedImage;
      });
    });
    imageprovider.networkImageToFile(widget.patient.Model["graduationCertificate"]).then((_) {
      setState(() {
        grad = imageprovider.selectedImage;
        gradOld = imageprovider.selectedImage;
      });
    });
    imageprovider.networkImageToFile(widget.patient.Model["criminalRecordAndIdentification"]).then((_) {
      setState(() {
        crim = imageprovider.selectedImage;
        crimOld = imageprovider.selectedImage;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    var imageprovider = Provider.of<UploadProvider>(context, listen: false);
    final patientProvider = Provider.of<NurseProvider>(context, listen: false);

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
              buildTextField("Password", passController),
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

                    final idUrl = await imageprovider
                        .uploadImageToCloudinary(idCard);
                    final pfpUrl = await imageprovider
                        .uploadImageToCloudinary(pfp);

                    if (idUrl == null || pfpUrl  == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(content: Text(
                            "Image upload failed. Try again.")),
                      );
                      return;
                    }
                    await patientProvider.updateNurse(
                      id: widget.patient.Model['id'] ?? 0, // Ensure this exists
                      fullName: nameController.text,
                      idCard: widget.patient.Model['idCard'] ?? '',
                      email: emailController.text,
                      password: passController.text,
                      contact: phoneController.text,
                      dob : dobController.text,
                      gender: gender,
                      location: widget.patient.Model['location'] ?? 'Unknown',
                      crim: widget.patient.Model['criminalRecordAndIdentification'] ?? 'Unknown',
                      spec: widget.patient.Model['specialaization'] ?? 'Unknown',
                      grad: widget.patient.Model['graduationCertificate'] ?? 'Unknown',
                      prof: widget.patient.Model['professionalPracticeLicense'] ?? 'Unknown',
                      pfp: widget.patient.Model['personalPicture'] ?? 'Unknown',
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
