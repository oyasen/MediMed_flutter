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
  late TextEditingController locCont;
  late TextEditingController SpecCont;
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
    locCont = TextEditingController(text: data['location'] ?? ''); // Initialize locCont
    SpecCont = TextEditingController(text: data['specialaization'] ?? '');
    passController = TextEditingController(text: data['password'] ?? ''); // Initialize passController
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
              buildTextField("Location", locCont),
              buildTextField("Specialization", SpecCont),
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
              // ID Card Image Selector
              buildImageSelector("ID Card", idCard, (File? image) {
                setState(() {
                  idCard = image;
                });
              }),
              // Personal Picture Image Selector
              buildImageSelector("Personal Picture", pfp, (File? image) {
                setState(() {
                  pfp = image;
                });
              }),
              // Professional Practice License Image Selector
              buildImageSelector("Professional Practice License", prof, (File? image) {
                setState(() {
                  prof = image;
                });
              }),
              // Graduation Certificate Image Selector
              buildImageSelector("Graduation Certificate", grad, (File? image) {
                setState(() {
                  grad = image;
                });
              }),
              // Criminal Record and Identification Image Selector
              buildImageSelector("Criminal Record and Identification", crim, (File? image) {
                setState(() {
                  crim = image;
                });
              }),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (idCard == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select an ID Card image")),
                      );
                      return;
                    }
                    if (pfp == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a Personal Picture image")),
                      );
                      return;
                    }
                    if (prof == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a Professional Practice License image")),
                      );
                      return;
                    }
                    if (grad == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a Graduation Certificate image")),
                      );
                      return;
                    }
                    if (crim == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a Criminal Record and Identification image")),
                      );
                      return;
                    }

                    final idUrl = await imageprovider.uploadImageToCloudinary(idCard);
                    final pfpUrl = await imageprovider.uploadImageToCloudinary(pfp);
                    final profUrl = await imageprovider.uploadImageToCloudinary(prof);
                    final gradUrl = await imageprovider.uploadImageToCloudinary(grad);
                    final crimUrl = await imageprovider.uploadImageToCloudinary(crim);

                    if (idUrl == null || pfpUrl == null || profUrl == null || gradUrl == null || crimUrl == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Image upload failed. Try again.")),
                      );
                      return;
                    }
                    print('Gender: $gender');
                    print('Location: ${locCont.text}');
                    print('Personal Picture URL: $pfpUrl');
                    await patientProvider.updateNurse(
                      id: widget.patient.Model['id'] ?? 0,
                      fullName: nameController.text,
                      idCard: idUrl,
                      email: emailController.text,
                      password: passController.text,
                      contact: phoneController.text,
                      dob: dobController.text,
                      gender: gender,
                      location: locCont.text,
                      crim: crimUrl,
                      spec: SpecCont.text,
                      grad: gradUrl,
                      prof: profUrl,
                      pfp: pfpUrl,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully!')),
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

  Widget buildImageSelector(String label, File? image, Function(File?) onImageSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  File? selectedImage = await Provider.of<UploadProvider>(context, listen: false).showOptions(context);
                  if (selectedImage != null) {
                    onImageSelected(selectedImage);
                  }
                },
                child: Text("Pick Image"),
              ),
              Visibility(
                visible: image != null,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        onImageSelected(null);
                      },
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    if (image != null)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image,
                            width: 50,
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
    );
  }
}