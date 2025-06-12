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

class _UpdateProfilePageState extends State<UpdateNurseProfile>
    with TickerProviderStateMixin {
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

  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize animations
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.elasticOut,
    ));

    _cardSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.bounceOut,
    ));

    // Start animations
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _fabAnimationController.forward();
    });

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
  void dispose() {
    _headerAnimationController.dispose();
    _cardAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var imageprovider = Provider.of<UploadProvider>(context, listen: false);
    final patientProvider = Provider.of<NurseProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
                Color(0xFFF093FB),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Animated background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF0F4F8),
                  Color(0xFFE2E8F0),
                  Color(0xFFF7FAFC),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                // Spectacular Header with floating profile
                AnimatedBuilder(
                  animation: _headerAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _headerAnimation.value,
                      child: Container(
                        height: 280,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                              Color(0xFFF093FB),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667EEA).withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Floating circles decoration
                            Positioned(
                              top: 50,
                              right: 30,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: 40,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 180,
                              right: 80,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                            ),

                            // Main content
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 60),

                                  // Profile picture with glow effect
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [Colors.white, Color(0xFFF8FAFC)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                        BoxShadow(
                                          color: const Color(0xFF667EEA).withOpacity(0.3),
                                          blurRadius: 30,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.8),
                                          width: 3,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 52,
                                        backgroundImage: NetworkImage(
                                          widget.patient.Model['personalPicture'] ??
                                              'https://via.placeholder.com/150',
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Welcome text with animation
                                  Text(
                                    'Update Your Profile',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    'Keep your information up to date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                AnimatedBuilder(
                  animation: _cardSlideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _cardSlideAnimation.value)),
                      child: Opacity(
                        opacity: _cardSlideAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Personal Information Section with glassmorphism
                              _buildSpectacularSectionCard(
                                "Personal Information",
                                Icons.person_outline,
                                const Color(0xFF667EEA),
                                [
                                  buildSpectacularTextField("Full Name", nameController, Icons.person_outline),
                                  buildSpectacularTextField("Phone Number", phoneController, Icons.phone_outlined, isNumber: true),
                                  buildSpectacularTextField("Email", emailController, Icons.email_outlined),
                                  buildSpectacularTextField("Date Of Birth", dobController, Icons.calendar_today_outlined),
                                  buildSpectacularTextField("Password", passController, Icons.lock_outline, isPassword: true),
                                  buildSpectacularTextField("Location", locCont, Icons.location_on_outlined),
                                  buildSpectacularTextField("Specialization", SpecCont, Icons.medical_services_outlined),

                                  // Gender Selection with modern design
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Gender",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.white.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFF667EEA).withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF667EEA).withOpacity(0.1),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              gradient: gender == "Male"
                                                  ? const LinearGradient(
                                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                              )
                                                  : null,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: RadioListTile<String>(
                                              title: Text(
                                                "Male",
                                                style: TextStyle(
                                                  color: gender == "Male" ? Colors.white : const Color(0xFF2D3748),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              value: "Male",
                                              groupValue: gender,
                                              onChanged: (value) {
                                                setState(() {
                                                  gender = value!;
                                                });
                                              },
                                              activeColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              gradient: gender == "Female"
                                                  ? const LinearGradient(
                                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                              )
                                                  : null,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: RadioListTile<String>(
                                              title: Text(
                                                "Female",
                                                style: TextStyle(
                                                  color: gender == "Female" ? Colors.white : const Color(0xFF2D3748),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              value: "Female",
                                              groupValue: gender,
                                              onChanged: (value) {
                                                setState(() {
                                                  gender = value!;
                                                });
                                              },
                                              activeColor: Colors.white,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Documents Section
                              _buildSpectacularSectionCard(
                                "Required Documents",
                                Icons.folder_open,
                                const Color(0xFF764BA2),
                                [
                                  buildSpectacularImageSelector("ID Card", idCard, Icons.badge, (File? image) {
                                    setState(() {
                                      idCard = image;
                                    });
                                  }),
                                  buildSpectacularImageSelector("Personal Picture", pfp, Icons.portrait, (File? image) {
                                    setState(() {
                                      pfp = image;
                                    });
                                  }),
                                  buildSpectacularImageSelector("Professional Practice License", prof, Icons.work, (File? image) {
                                    setState(() {
                                      prof = image;
                                    });
                                  }),
                                  buildSpectacularImageSelector("Graduation Certificate", grad, Icons.school, (File? image) {
                                    setState(() {
                                      grad = image;
                                    });
                                  }),
                                  buildSpectacularImageSelector("Criminal Record and Identification", crim, Icons.security, (File? image) {
                                    setState(() {
                                      crim = image;
                                    });
                                  }),
                                ],
                              ),

                              const SizedBox(height: 40),

                              // Spectacular Update Button
                              AnimatedBuilder(
                                animation: _fabScaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _fabScaleAnimation.value,
                                    child: Container(
                                      width: double.infinity,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF667EEA),
                                            Color(0xFF764BA2),
                                            Color(0xFFF093FB),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF667EEA).withOpacity(0.4),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (idCard == null) {
                                            _showSpectacularErrorSnackBar("Please select an ID Card image");
                                            return;
                                          }
                                          if (pfp == null) {
                                            _showSpectacularErrorSnackBar("Please select a Personal Picture image");
                                            return;
                                          }
                                          if (prof == null) {
                                            _showSpectacularErrorSnackBar("Please select a Professional Practice License image");
                                            return;
                                          }
                                          if (grad == null) {
                                            _showSpectacularErrorSnackBar("Please select a Graduation Certificate image");
                                            return;
                                          }
                                          if (crim == null) {
                                            _showSpectacularErrorSnackBar("Please select a Criminal Record and Identification image");
                                            return;
                                          }

                                          // Show spectacular loading dialog
                                          _showSpectacularLoadingDialog();

                                          try {
                                            final idUrl = await imageprovider.uploadImageToCloudinary(idCard);
                                            final pfpUrl = await imageprovider.uploadImageToCloudinary(pfp);
                                            final profUrl = await imageprovider.uploadImageToCloudinary(prof);
                                            final gradUrl = await imageprovider.uploadImageToCloudinary(grad);
                                            final crimUrl = await imageprovider.uploadImageToCloudinary(crim);

                                            if (idUrl == null || pfpUrl == null || profUrl == null || gradUrl == null || crimUrl == null) {
                                              Navigator.pop(context);
                                              _showSpectacularErrorSnackBar("Image upload failed. Try again.");
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

                                            Navigator.pop(context);
                                            _showSpectacularSuccessSnackBar('Profile updated successfully!');
                                            Navigator.pop(context);
                                          } catch (e) {
                                            Navigator.pop(context);
                                            _showSpectacularErrorSnackBar('Update failed. Please try again.');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.rocket_launch, color: Colors.white, size: 24),
                                            SizedBox(width: 12),
                                            Text(
                                              'Update Profile',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpectacularSectionCard(String title, IconData icon, Color accentColor, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.1),
                  accentColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSpectacularTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildSpectacularImageSelector(String label, File? image, IconData icon, Function(File?) onImageSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF667EEA).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (image != null) ...[
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action buttons with spectacular design
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          File? selectedImage = await Provider.of<UploadProvider>(context, listen: false).showOptions(context);
                          if (selectedImage != null) {
                            onImageSelected(selectedImage);
                          }
                        },
                        icon: Icon(icon, size: 20, color: Colors.white),
                        label: Text(
                          image == null ? "Pick Image" : "Change Image",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),

                    if (image != null)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFEF4444).withOpacity(0.1),
                              const Color(0xFFEF4444).withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color(0xFFEF4444).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            onImageSelected(null);
                          },
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showSpectacularLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color(0xFFF8FAFC),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Updating Profile...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we save your changes',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSpectacularErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSpectacularSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}