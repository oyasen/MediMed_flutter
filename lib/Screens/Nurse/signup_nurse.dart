import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medimed/Screens/Nurse/login_nurse.dart';
import 'package:medimed/Screens/validation.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';

class SignupNurse extends StatefulWidget {
  const SignupNurse({super.key});

  @override
  State<SignupNurse> createState() => _SignupState();
}

class _SignupState extends State<SignupNurse> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController spec = TextEditingController();
  TextEditingController loc = TextEditingController();

  String? gender;
  File? idCard;
  File? prof;
  File? grad;
  File? crim;
  File? pfp;
  final formKey = GlobalKey<FormState>();
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    var imageprovider = Provider.of<UploadProvider>(context, listen: false);
    var nurseProvider = Provider.of<NurseProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748), size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Registration',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Join Our Medical Team',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Create your professional healthcare profile',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Form Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 25,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Information Section
                          _buildSectionHeader('Personal Information', Icons.person_outline),
                          const SizedBox(height: 20),

                          _buildElegantFormField(
                            label: "Full Name",
                            controller: fullName,
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.name,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),

                          _buildElegantFormField(
                            label: "Email Address",
                            controller: email,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!isValidEmail(text)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: _buildElegantFormField(
                                  label: "Password",
                                  controller: password,
                                  icon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return 'Please enter password';
                                    }
                                    if (!isValidPass(text)) {
                                      return 'Password format incorrect';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildElegantFormField(
                                  label: "Confirm Password",
                                  controller: confirmPass,
                                  icon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return 'Please confirm password';
                                    }
                                    if (password.text != text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: _buildElegantFormField(
                                  label: "Date of Birth",
                                  controller: dob,
                                  icon: Icons.calendar_today_outlined,
                                  keyboardType: TextInputType.datetime,
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return 'Please enter date of birth';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildElegantFormField(
                                  label: "Phone Number",
                                  controller: contact,
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  validator: (text) {
                                    if (text == null || text.trim().isEmpty) {
                                      return 'Please enter phone number';
                                    }
                                    if (!isValidContact(text)) {
                                      return 'Invalid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Gender Selection
                          const SizedBox(height: 20),
                          const Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildGenderOption('Male', Icons.male),
                                ),
                                Container(
                                  width: 1,
                                  height: 50,
                                  color: const Color(0xFFE2E8F0),
                                ),
                                Expanded(
                                  child: _buildGenderOption('Female', Icons.female),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Professional Information Section
                          _buildSectionHeader('Professional Information', Icons.work_outline),
                          const SizedBox(height: 20),

                          _buildElegantFormField(
                            label: "Specialization",
                            controller: spec,
                            icon: Icons.medical_services_outlined,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please enter your specialization';
                              }
                              return null;
                            },
                          ),

                          _buildElegantFormField(
                            label: "Practice Location",
                            controller: loc,
                            icon: Icons.location_on_outlined,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please enter practice location';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Documents Section
                          _buildSectionHeader('Required Documents', Icons.folder_outlined),
                          const SizedBox(height: 20),

                          _buildDocumentUpload(
                            title: 'Profile Picture',
                            description: 'Upload a professional headshot',
                            icon: Icons.person,
                            file: pfp,
                            onTap: () async {
                              File? selectedImage = await imageprovider.showOptions(context);
                              if (selectedImage != null) {
                                setState(() {
                                  pfp = selectedImage;
                                });
                              }
                            },
                            onDelete: () {
                              setState(() {
                                pfp = null;
                              });
                            },
                            isRequired: false,
                          ),

                          _buildDocumentUpload(
                            title: 'National ID Card',
                            description: 'Clear photo of your identification',
                            icon: Icons.badge,
                            file: idCard,
                            onTap: () async {
                              File? selectedImage = await imageprovider.showOptions(context);
                              if (selectedImage != null) {
                                setState(() {
                                  idCard = selectedImage;
                                });
                              }
                            },
                            onDelete: () {
                              setState(() {
                                idCard = null;
                              });
                            },
                          ),

                          _buildDocumentUpload(
                            title: 'Professional License',
                            description: 'Valid nursing practice license',
                            icon: Icons.verified,
                            file: prof,
                            onTap: () async {
                              File? selectedImage = await imageprovider.showOptions(context);
                              if (selectedImage != null) {
                                setState(() {
                                  prof = selectedImage;
                                });
                              }
                            },
                            onDelete: () {
                              setState(() {
                                prof = null;
                              });
                            },
                          ),

                          _buildDocumentUpload(
                            title: 'Academic Certificate',
                            description: 'Nursing degree or diploma',
                            icon: Icons.school,
                            file: grad,
                            onTap: () async {
                              File? selectedImage = await imageprovider.showOptions(context);
                              if (selectedImage != null) {
                                setState(() {
                                  grad = selectedImage;
                                });
                              }
                            },
                            onDelete: () {
                              setState(() {
                                grad = null;
                              });
                            },
                          ),

                          _buildDocumentUpload(
                            title: 'Background Check',
                            description: 'Criminal record clearance',
                            icon: Icons.security,
                            file: crim,
                            onTap: () async {
                              File? selectedImage = await imageprovider.showOptions(context);
                              if (selectedImage != null) {
                                setState(() {
                                  crim = selectedImage;
                                });
                              }
                            },
                            onDelete: () {
                              setState(() {
                                crim = null;
                              });
                            },
                          ),

                          const SizedBox(height: 32),

                          // Terms and Conditions
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline, size: 20, color: Color(0xFF667EEA)),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'By creating an account, you agree to our Terms & Conditions and Privacy Policy. Your information will be verified for professional healthcare standards.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF4A5568),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => _handleSubmit(imageprovider, nurseProvider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF667EEA),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadowColor: const Color(0xFF667EEA).withOpacity(0.3),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.how_to_reg, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Complete Registration',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Sign In Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignInPage()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Color(0xFF667EEA),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF667EEA) : const Color(0xFFE2E8F0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF718096),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF667EEA) : const Color(0xFF718096),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        color: isActive ? const Color(0xFF667EEA) : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF667EEA),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildElegantFormField({
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
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF667EEA), size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = this.gender == gender;
    return InkWell(
      onTap: () {
        setState(() {
          this.gender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF667EEA) : const Color(0xFF718096),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? const Color(0xFF667EEA) : const Color(0xFF718096),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF667EEA),
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUpload({
    required String title,
    required String description,
    required IconData icon,
    required File? file,
    required VoidCallback onTap,
    required VoidCallback onDelete,
    bool isRequired = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: file != null ? const Color(0xFF48BB78) : const Color(0xFFE2E8F0),
        ),
        borderRadius: BorderRadius.circular(12),
        color: file != null ? const Color(0xFF48BB78).withOpacity(0.05) : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: file != null
                    ? const Color(0xFF48BB78).withOpacity(0.1)
                    : const Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                file != null ? Icons.check_circle : icon,
                color: file != null ? const Color(0xFF48BB78) : const Color(0xFF667EEA),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isRequired) ...[
                        const SizedBox(width: 4),
                        const Text(
                          '*',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    file != null ? 'Document uploaded successfully' : description,
                    style: TextStyle(
                      fontSize: 13,
                      color: file != null ? const Color(0xFF48BB78) : const Color(0xFF718096),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            file != null
                ? IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  )
                : ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667EEA),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Upload'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit(UploadProvider imageprovider, NurseProvider nurseProvider) async {
    if (!formKey.currentState!.validate()) return;

    // Validate required fields
    final validationErrors = <String>[];

    if (gender == null) validationErrors.add("Please select your gender");
    if (idCard == null) validationErrors.add("Please upload your ID card");
    if (prof == null) validationErrors.add("Please upload your professional license");
    if (grad == null) validationErrors.add("Please upload your academic certificate");
    if (crim == null) validationErrors.add("Please upload your background check");

    if (validationErrors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationErrors.first),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF667EEA)),
      ),
    );

    try {
      // Upload images
      final idCardUrl = await imageprovider.uploadImageToCloudinary(idCard);
      final profUrl = await imageprovider.uploadImageToCloudinary(prof);
      final gradUrl = await imageprovider.uploadImageToCloudinary(grad);
      final crimUrl = await imageprovider.uploadImageToCloudinary(crim);
      final pfpUrl = pfp != null ? await imageprovider.uploadImageToCloudinary(pfp) : null;

      if (idCardUrl == null || profUrl == null || gradUrl == null || crimUrl == null) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to upload documents. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Register nurse
      await nurseProvider.addNurse(
        fullName: fullName.text,
        email: email.text,
        password: password.text,
        contact: contact.text,
        grad: gradUrl,
        crim: crimUrl,
        idCard: idCardUrl,
        prof: profUrl,
        spec: spec.text,
        location: loc.text,
        gender: gender!,
        dob: dob.text,
        pfp: pfpUrl ?? '',
      );

      Navigator.pop(context); // Close loading

      if (nurseProvider.nurseAddModel?.id != 0) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text("Registration successful! Please sign in."),
              ],
            ),
            backgroundColor: const Color(0xFF48BB78),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  bool isValidEmail(String email) {
    // Add your email validation logic here
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPass(String password) {
    // Add your password validation logic here
    return password.length >= 6;
  }

  bool isValidContact(String contact) {
    // Add your contact validation logic here
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(contact);
  }
}