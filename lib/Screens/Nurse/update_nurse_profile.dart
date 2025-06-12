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
    locCont = TextEditingController(text: data['location'] ?? '');
    SpecCont = TextEditingController(text: data['specialaization'] ?? '');
    passController = TextEditingController(text: data['password'] ?? '');
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with curved background
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          widget.patient.Model['personalPicture'] ?? 'https://via.placeholder.com/150',
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information Section
                  _buildSectionCard(
                    "Personal Information",
                    Icons.person,
                    [
                      buildTextField("Full Name", nameController, Icons.person_outline),
                      buildTextField("Phone Number", phoneController, Icons.phone_outlined, isNumber: true),
                      buildTextField("Email", emailController, Icons.email_outlined),
                      buildTextField("Date Of Birth", dobController, Icons.calendar_today_outlined),
                      buildTextField("Password", passController, Icons.lock_outline, isPassword: true),
                      buildTextField("Location", locCont, Icons.location_on_outlined),
                      buildTextField("Specialization", SpecCont, Icons.medical_services_outlined),

                      // Gender Selection
                      const SizedBox(height: 16),
                      const Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
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
                                activeColor: const Color(0xFF3B82F6),
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
                                activeColor: const Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Documents Section
                  _buildSectionCard(
                    "Required Documents",
                    Icons.folder,
                    [
                      buildImageSelector("ID Card", idCard, Icons.badge, (File? image) {
                        setState(() {
                          idCard = image;
                        });
                      }),
                      buildImageSelector("Personal Picture", pfp, Icons.portrait, (File? image) {
                        setState(() {
                          pfp = image;
                        });
                      }),
                      buildImageSelector("Professional Practice License", prof, Icons.work, (File? image) {
                        setState(() {
                          prof = image;
                        });
                      }),
                      buildImageSelector("Graduation Certificate", grad, Icons.school, (File? image) {
                        setState(() {
                          grad = image;
                        });
                      }),
                      buildImageSelector("Criminal Record and Identification", crim, Icons.security, (File? image) {
                        setState(() {
                          crim = image;
                        });
                      }),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (idCard == null) {
                          _showErrorSnackBar("Please select an ID Card image");
                          return;
                        }
                        if (pfp == null) {
                          _showErrorSnackBar("Please select a Personal Picture image");
                          return;
                        }
                        if (prof == null) {
                          _showErrorSnackBar("Please select a Professional Practice License image");
                          return;
                        }
                        if (grad == null) {
                          _showErrorSnackBar("Please select a Graduation Certificate image");
                          return;
                        }
                        if (crim == null) {
                          _showErrorSnackBar("Please select a Criminal Record and Identification image");
                          return;
                        }

                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        );

                        try {
                          final idUrl = await imageprovider.uploadImageToCloudinary(idCard);
                          final pfpUrl = await imageprovider.uploadImageToCloudinary(pfp);
                          final profUrl = await imageprovider.uploadImageToCloudinary(prof);
                          final gradUrl = await imageprovider.uploadImageToCloudinary(grad);
                          final crimUrl = await imageprovider.uploadImageToCloudinary(crim);

                          if (idUrl == null || pfpUrl == null || profUrl == null || gradUrl == null || crimUrl == null) {
                            Navigator.pop(context); // Close loading dialog
                            _showErrorSnackBar("Image upload failed. Try again.");
                            return;
                          }

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

                          Navigator.pop(context); // Close loading dialog
                          _showSuccessSnackBar('Profile updated successfully!');
                          Navigator.pop(context);
                        } catch (e) {
                          Navigator.pop(context); // Close loading dialog
                          _showErrorSnackBar('Update failed. Please try again.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.update, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Update Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildImageSelector(String label, File? image, IconData icon, Function(File?) onImageSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              if (image != null) ...[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      File? selectedImage = await Provider.of<UploadProvider>(context, listen: false).showOptions(context);
                      if (selectedImage != null) {
                        onImageSelected(selectedImage);
                      }
                    },
                    icon: Icon(icon, size: 18),
                    label: Text(
                      image == null ? "Pick Image" : "Change Image",
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                  if (image != null)
                    IconButton(
                      onPressed: () {
                        onImageSelected(null);
                      },
                      icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}