import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medimed/Screens/Patient/section1/signin.dart';
import 'package:medimed/Screens/validation.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController contact = TextEditingController();

  String? gender;
  File? idCard;
  File? pfp;

  @override
  Widget build(BuildContext context) {
    var imageprovider = Provider.of<UploadProvider>(context, listen: false);
    var patientProvider = Provider.of<PatientProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6366f1), Color(0xff8b5cf6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Registration',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 40), // Balance the back button
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medical_services_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Join Our Medical\nTeam',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Create your professional healthcare\nprofile',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xff6366f1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xff6366f1),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1f2937),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _buildModernFormField(
                        label: "Full Name",
                        controller: fullName,
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                        validator: (text) => text!.isEmpty ? 'Enter full name' : null,
                      ),

                      _buildModernFormField(
                        label: "Email Address",
                        controller: email,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text!.isEmpty) return 'Enter email';
                          if (!isValidEmail(text)) return 'Invalid email format';
                          return null;
                        },
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildModernFormField(
                              label: "Password",
                              controller: password,
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (text) {
                                if (text!.isEmpty) return 'Enter password';
                                if (!isValidPass(text)) return 'Weak password';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildModernFormField(
                              label: "Confirm Password",
                              controller: confirmPass,
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (text) => text != password.text ? 'Passwords do not match' : null,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildModernFormField(
                              label: "Date of Birth",
                              controller: dob,
                              icon: Icons.calendar_today_outlined,
                              keyboardType: TextInputType.datetime,
                              validator: (text) => text!.isEmpty ? 'Enter birth date' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildModernFormField(
                              label: "Phone Number",
                              controller: contact,
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text!.isEmpty) return 'Enter phone number';
                                if (!isValidContact(text)) return 'Invalid phone';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff374151),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffe5e7eb)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => gender = "Male"),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: gender == "Male" ? const Color(0xff6366f1) : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Male",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: gender == "Male" ? Colors.white : const Color(0xff6b7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 48,
                              color: const Color(0xffe5e7eb),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => gender = "Female"),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: gender == "Female" ? const Color(0xff6366f1) : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Female",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: gender == "Female" ? Colors.white : const Color(0xff6b7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      _buildImagePicker(
                        label: "ID Card",
                        file: idCard,
                        onPick: () async {
                          final img = await imageprovider.showOptions(context);
                          if (img != null) setState(() => idCard = img);
                        },
                        onDelete: () => setState(() => idCard = null),
                      ),

                      _buildImagePicker(
                        label: "Personal Picture",
                        file: pfp,
                        onPick: () async {
                          final img = await imageprovider.showOptions(context);
                          if (img != null) setState(() => pfp = img);
                        },
                        onDelete: () => setState(() => pfp = null),
                      ),

                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6366f1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (gender == null || idCard == null || pfp == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Complete all fields")),
                                );
                                return;
                              }

                              final idCardUrl = await imageprovider.uploadImageToCloudinary(idCard);
                              final pfpUrl = await imageprovider.uploadImageToCloudinary(pfp);

                              if (idCardUrl == null || pfpUrl == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Image upload failed")),
                                );
                                return;
                              }

                              await patientProvider.addPatient(
                                fullName: fullName.text,
                                url: idCardUrl,
                                email: email.text,
                                pass: password.text,
                                contact: contact.text,
                                date: dob.text,
                                gender: gender!,
                                pfp: pfpUrl,
                              );

                              if (patientProvider.patientAddModel?.id != 0) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Signin()),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: const Color(0xff6b7280),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Signin()),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color(0xff6366f1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff374151),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: const Color(0xff6b7280),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xffe5e7eb)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xffe5e7eb)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xff6366f1), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xfff87171)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xfff87171), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xfff9fafb),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required File? file,
    required VoidCallback onPick,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff374151),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5e7eb)),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xfff9fafb),
            ),
            child: file == null
                ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff6366f1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Color(0xff6366f1),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onPick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6366f1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Choose File"),
                ),
              ],
            )
                : Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    file,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.path.split('/').last,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "File uploaded successfully",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff10b981),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xfff87171),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}