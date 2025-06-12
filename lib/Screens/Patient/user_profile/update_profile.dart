import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _UpdateProfilePageState extends State<UpdateProfilePage>
    with TickerProviderStateMixin {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late String gender;
  File? idCard;
  File? pfp;
  bool _isLoading = false;

  late AnimationController _animationController;
  late AnimationController _avatarController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _avatarController,
      curve: Curves.elasticOut,
    ));

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

    _avatarController.forward();
    Future.delayed(Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    var imageprovider = Provider.of<UploadProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 44),
                  ],
                ),
              ),

              // Profile Avatar Section
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.white.withOpacity(0.8)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: CircleAvatar(
                                radius: 56,
                                backgroundImage: pfp != null
                                    ? FileImage(pfp!)
                                    : NetworkImage(widget.patient.Model['personalPicture'] ??
                                    'https://via.placeholder.com/150') as ImageProvider,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                File? selectedImage = await imageprovider.showOptions(context);
                                if (selectedImage != null) {
                                  setState(() {
                                    pfp = selectedImage;
                                  });
                                  HapticFeedback.lightImpact();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF00BFFF), Color(0xFF0080FF)],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF00BFFF).withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Form Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              children: [
                                SizedBox(height: 10),

                                // Personal Information Section
                                _buildSectionHeader("Personal Information", Icons.person),
                                SizedBox(height: 20),

                                _buildAnimatedTextField(
                                  "Full Name",
                                  nameController,
                                  Icons.person_outline,
                                  delay: 0.1,
                                ),

                                _buildAnimatedTextField(
                                  "Phone Number",
                                  phoneController,
                                  Icons.phone_outlined,
                                  isNumber: true,
                                  delay: 0.2,
                                ),

                                _buildAnimatedTextField(
                                  "Email Address",
                                  emailController,
                                  Icons.email_outlined,
                                  delay: 0.3,
                                ),

                                _buildAnimatedTextField(
                                  "Date of Birth",
                                  dobController,
                                  Icons.calendar_today_outlined,
                                  delay: 0.4,
                                ),

                                // Gender Selection
                                _buildGenderSelection(),

                                // Documents Section
                                _buildSectionHeader("Documents", Icons.folder),
                                SizedBox(height: 20),

                                _buildImageUploadCard(
                                  "ID Card",
                                  "Upload your identification document",
                                  Icons.credit_card,
                                  idCard,
                                      () async {
                                    File? selectedImage = await imageprovider.showOptions(context);
                                    if (selectedImage != null) {
                                      setState(() {
                                        idCard = selectedImage;
                                      });
                                      HapticFeedback.lightImpact();
                                    }
                                  },
                                      () {
                                    setState(() {
                                      idCard = null;
                                    });
                                  },
                                ),

                                SizedBox(height: 40),

                                // Update Button
                                _buildUpdateButton(patientProvider, imageprovider),

                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00BFFF), Color(0xFF0080FF)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedTextField(
      String label,
      TextEditingController controller,
      IconData icon, {
        bool isNumber = false,
        double delay = 0.0,
      }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 30),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller,
                      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Enter $label',
                        prefixIcon: Icon(icon, color: Color(0xFF00BFFF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderSelection() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      gender = "Male";
                    });
                    HapticFeedback.lightImpact();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: gender == "Male"
                          ? LinearGradient(colors: [Color(0xFF00BFFF), Color(0xFF0080FF)])
                          : null,
                      color: gender != "Male" ? Colors.white : null,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: gender == "Male" ? Colors.transparent : Colors.grey[300]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gender == "Male"
                              ? Color(0xFF00BFFF).withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.male,
                          color: gender == "Male" ? Colors.white : Colors.grey[600],
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Male",
                          style: TextStyle(
                            color: gender == "Male" ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      gender = "Female";
                    });
                    HapticFeedback.lightImpact();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: gender == "Female"
                          ? LinearGradient(colors: [Color(0xFFf093fb), Color(0xFFf5576c)])
                          : null,
                      color: gender != "Female" ? Colors.white : null,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: gender == "Female" ? Colors.transparent : Colors.grey[300]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gender == "Female"
                              ? Color(0xFFf093fb).withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.female,
                          color: gender == "Female" ? Colors.white : Colors.grey[600],
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Female",
                          style: TextStyle(
                            color: gender == "Female" ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadCard(
      String title,
      String subtitle,
      IconData icon,
      File? image,
      VoidCallback onTap,
      VoidCallback onDelete,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: Icon(Icons.upload, color: Colors.white),
                  label: Text(
                    image == null ? "Upload Image" : "Change Image",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00BFFF),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (image != null) ...[
                SizedBox(width: 12),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ),
                SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(PatientProvider patientProvider, UploadProvider imageprovider) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00BFFF), Color(0xFF0080FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00BFFF).withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () async {
          setState(() {
            _isLoading = true;
          });

          try {
            if (idCard == null) {
              _showErrorSnackBar("Please select an ID Card image");
              return;
            }
            if (pfp == null) {
              _showErrorSnackBar("Please select a Personal Picture");
              return;
            }

            final imageUrl = await imageprovider.uploadImageToCloudinary(idCard);
            final pfpUrl = await imageprovider.uploadImageToCloudinary(pfp);

            if (imageUrl == null || pfpUrl == null) {
              _showErrorSnackBar("Image upload failed. Try again.");
              return;
            }

            await patientProvider.updatePatient(
              id: widget.patient.Model['id'] ?? 0,
              fullname: nameController.text,
              date: dobController.text,
              email: emailController.text,
              contact: phoneController.text,
              url: imageUrl,
              pass: widget.patient.Model['password'] ?? '',
              gender: gender,
              pfp: pfpUrl,
            );

            _showSuccessSnackBar('Profile updated successfully!');
            Navigator.pop(context);
          } catch (e) {
            _showErrorSnackBar('Update failed. Please try again.');
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}