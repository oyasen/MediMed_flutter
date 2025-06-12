import 'package:flutter/material.dart';
import 'package:medimed/Screens/Patient/user_profile/Notifications.dart';
import 'package:medimed/Screens/Patient/section5_nurseprofile/nurser_profile.dart';
import 'package:medimed/Screens/Patient/user_profile/setting.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';

import '../user_profile/my_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var patientProvider = Provider.of<PatientProvider>(context);
    patientProvider.getPatientById(patientProvider.patientAddModel!.id);
    patientProvider.getPatientsNurse(patientProvider.patientAddModel!.id);
    var patient = patientProvider.patientModel;

    if(patient == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0299C6), Color(0xFF00B4DB)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0299C6)),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading your dashboard...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if(patient.Model["approved"] != "Accepted") {
      return _buildPendingApprovalScreen(patient);
    }

    final List<Widget> _pages = [
      // Home Page Content
      Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0299C6),
                          Color(0xFF00B4DB),
                          Color(0xFF0090FF),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Consumer<PatientProvider>(
                            builder: (context, provider, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: provider.patientModel?.Model["idCard"] != null
                                      ? NetworkImage(provider.patientModel!.Model["idCard"])
                                      : null,
                                  backgroundColor: Colors.white,
                                  child: provider.patientModel?.Model["idCard"] == null
                                      ? Icon(Icons.person, color: Color(0xFF0299C6), size: 35)
                                      : null,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Consumer<PatientProvider>(
                              builder: (context, provider, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Welcome Back! 👋',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      provider.patientModel?.Model["fullName"] ?? 'User',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          _buildActionButton(
                            icon: Icons.notifications_outlined,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientNotificationsPage(
                                      patientId: patientProvider.patientAddModel!.id
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 8),
                          _buildActionButton(
                            icon: Icons.settings_outlined,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for healthcare services...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Container(
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF0299C6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.search_rounded,
                                color: Color(0xFF0299C6),
                                size: 20,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Categories Section
                      Text(
                        'Healthcare Categories',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 16),

                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CategoryIcon(
                                title: 'Dentistry',
                                imageUrl: 'https://cdn-icons-png.flaticon.com/512/2947/2947853.png',
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            Expanded(
                              child: CategoryIcon(
                                title: 'Cardiology',
                                imageUrl: 'https://cdn-icons-png.flaticon.com/512/2966/2966327.png',
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            Expanded(
                              child: CategoryIcon(
                                title: 'Pulmonary',
                                imageUrl: 'https://cdn-icons-png.flaticon.com/512/1052/1052860.png',
                                color: Color(0xFF2196F3),
                              ),
                            ),
                            Expanded(
                              child: CategoryIcon(
                                title: 'General',
                                imageUrl: 'https://cdn-icons-png.flaticon.com/512/2921/2921822.png',
                                color: Color(0xFFFF9800),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      // Available Nurses Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Nurses',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: Color(0xFF0299C6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                sliver: Consumer<NurseProvider>(
                  builder: (context, value, child) {
                    if (value.nurseModel == null) {
                      value.getAllNurses();
                      return SliverToBoxAdapter(
                        child: Container(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0299C6)),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading available nurses...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      final approvedNurses = value.nurseModel!.Model
                          .where((nurse) => nurse["approved"] == "Accepted")
                          .toList();
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var nurse = approvedNurses[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: DoctorCard(
                                name: nurse['fullName'] ?? 'Nurse Name',
                                specialty: nurse['speciality'] ?? 'Specialization',
                                rating: nurse['rating']?.toDouble() ?? 5.0,
                                imageUrl: nurse['idCard'] ?? '',
                                nurseData: nurse,
                                patientData: patientProvider.patientAddModel!.id,
                              ),
                            );
                          },
                          childCount: approvedNurses.length,
                        ),
                      );
                    }
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom),
              ),
            ],
          ),
        ),
      ),
      // Profile Page
      ProfilePage(imageUrl: patient.Model["idCard"] ?? ''),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 8, bottom: MediaQuery.of(context).viewPadding.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 15,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Color(0xFF0299C6),
          unselectedItemColor: Colors.grey[400],
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.home_outlined,
                  size: 24,
                ),
              ),
              activeIcon: Container(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.home_rounded,
                  size: 24,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 24,
                ),
              ),
              activeIcon: Container(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.person_rounded,
                  size: 24,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildPendingApprovalScreen(patient) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0299C6),
                Color(0xFF00B4DB),
                Color(0xFF0090FF),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated pending icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                    ),
                    child: Icon(
                      Icons.hourglass_empty_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
        
                  SizedBox(height: 32),
        
                  // Main message
                  Text(
                    'Account Under Review',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
        
                  SizedBox(height: 16),
        
                  Text(
                    'Hi ${patient.Model["fullName"] ?? "User"}! 👋',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
        
                  SizedBox(height: 24),
        
                  // Info card
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 48,
                          color: Color(0xFF0299C6),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your account is currently being reviewed by our medical team.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4A4A4A),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F8FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFF0299C6).withOpacity(0.2)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.check_circle_outline, color: Color(0xFF4CAF50), size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Profile submitted successfully',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.schedule, color: Color(0xFFFF9800), size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Review typically takes 24-48 hours',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.notifications_active_outlined, color: Color(0xFF2196F3), size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'You\'ll be notified once approved',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 32),
        
                  // Action buttons
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add refresh/check status logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF0299C6),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh_rounded),
                              SizedBox(width: 8),
                              Text(
                                'Check Status',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            // Add contact support logic
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.support_agent_rounded),
                              SizedBox(width: 8),
                              Text(
                                'Contact Support',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;

  const CategoryIcon({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add navigation logic here
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  imageUrl,
                  width: 24,
                  height: 24,
                  color: color,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.medical_services_outlined,
                    color: color,
                    size: 24,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;
  final Map<String, dynamic> nurseData;
  final int patientData;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.nurseData,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NurseProfileScreen1(
                  nurseData: nurseData,
                  patientData: patientData,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF0299C6), Color(0xFF00B4DB)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF0299C6).withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                    backgroundColor: Colors.transparent,
                    child: imageUrl.isEmpty
                        ? Icon(Icons.person, color: Colors.white, size: 30)
                        : null,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        specialty,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF3CD),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Color(0xFFFFB020), size: 16),
                                SizedBox(width: 4),
                                Text(
                                  rating.toString(),
                                  style: TextStyle(
                                    color: Color(0xFFB8860B),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFFE8F5E8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Available',
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}