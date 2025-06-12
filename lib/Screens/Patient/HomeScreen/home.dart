import 'dart:ui';

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _searchQuery = '';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    final nurseProvider = Provider.of<NurseProvider>(context, listen: false);
    try {
      await patientProvider.getPatientById(patientProvider.patientAddModel!.id);
      await nurseProvider.getAllNurses();
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeController.forward();
        _slideController.forward();
      }
    } catch (e) {
      print("Error loading data: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var patientProvider = Provider.of<PatientProvider>(context);
    var nurseProvider = Provider.of<NurseProvider>(context);

    if (_isLoading) {
      return _buildLoadingScreen();
    }

    final List<Widget> _pages = [
      // Home Page Content
      Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
          slivers: [
                  // Custom App Bar
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                            Color(0xFF667eea),
                            Color(0xFF764ba2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF667eea).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                            child: Consumer<PatientProvider>(
                              builder: (context, provider, child) {
                                final imageUrl = provider.patientModel?.Model["profileImage"] ?? '';
                                return CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                                  child: imageUrl.isEmpty
                                      ? Icon(Icons.person, color: Color(0xFF667eea), size: 38)
                                      : null,
                              );
                            },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Consumer<PatientProvider>(
                              builder: (context, provider, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Good ${_getGreeting()}! 👋',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      provider.patientModel?.Model["fullName"] ?? 'User',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Find your perfect nurse',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Column(
                            children: [
                              _buildModernActionButton(
                                icon: Icons.notifications_none_rounded,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                      builder: (context) => NotificationsPage(
                                          id: patientProvider.patientAddModel!.id
                                  ),
                                ),
                              );
                            },
                          ),
                              SizedBox(height: 12),
                              _buildModernActionButton(
                            icon: Icons.settings_outlined,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                      builder: (context) => SettingsPage(id: patientProvider.patientAddModel!.id),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                        ],
                    ),
                  ),
                ),

                  // Quick Stats Cards
            SliverToBoxAdapter(
                    child: Container(
                      height: 70,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                  children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Available',
                              count: '${_getAvailableNursesCount(nurseProvider)}',
                              subtitle: 'Nurses',
                              color: Color(0xFF4CAF50),
                              icon: Icons.people_outline_rounded,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Rating',
                              count: '4.8',
                              subtitle: 'Average',
                              color: Color(0xFFFF9800),
                              icon: Icons.star_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 32)),

                    // Search Bar
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search nurses by name or specialty...',
                          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(14),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear_rounded, color: Colors.grey[400]),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Nurses',
                          style: TextStyle(
                                  fontSize: 24,
                            fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              Text(
                                'Choose the best care for you',
                            style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Color(0xFF667eea).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'View All',
                                style: TextStyle(
                                color: Color(0xFF667eea),
                                fontWeight: FontWeight.w600,
                                  fontSize: 14,
                              ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Nurses List
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    sliver: Consumer<NurseProvider>(
                      builder: (context, provider, child) {
                        if (provider.nurseModel?.Model == null) {
                          return SliverToBoxAdapter(
                            child: _buildShimmerLoading(),
                          );
                        }

                        List<dynamic> nurses = List.from(provider.nurseModel!.Model);
                        nurses = nurses.where((nurse) => nurse["approved"] == "Accepted").toList();

                        if (_searchQuery.isNotEmpty) {
                          nurses = nurses.where((nurse) {
                            final nurseName = (nurse['fullName'] ?? '').toString().toLowerCase();
                            final nurseSpecialty = (nurse['spec'] ?? '').toString().toLowerCase();
                            final query = _searchQuery.toLowerCase();
                            return nurseName.contains(query) || nurseSpecialty.contains(query);
                          }).toList();
                        }

                        if (nurses.isEmpty) {
                          return SliverToBoxAdapter(
                            child: _buildEmptyState(),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final nurse = nurses[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                                child: ModernNurseCard(
                                  name: nurse['fullName'] ?? 'Unknown',
                                  specialty: nurse['spec'] ?? 'General Nurse',
                                  rating: 4.5 + (index % 3) * 0.2,
                                  imageUrl: nurse['profileImage'] ?? '',
                                nurseData: nurse,
                                patientData: patientProvider.patientAddModel!.id,
                                  isOnline: index % 3 == 0,
                              ),
                            );
                          },
                            childCount: nurses.length,
                        ),
                      );
                  },
                ),
              ),

                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        ),
      ),
      // Profile Page
      ProfilePage(
        imageUrl: patientProvider.patientModel?.Model["idCard"] ?? '',
        id: patientProvider.patientAddModel!.id,
      ),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  Widget _buildModernActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
            padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Icon(
          icon,
          color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
            child: Column(
        mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Container(
                padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 10),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
                Text(
            count,
                  style: TextStyle(
              fontSize: 14,
                    fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
                  ),
                ),
          SizedBox(height: 1),
                Text(
            subtitle,
                  style: TextStyle(
              color: Colors.grey[500],
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
        borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 10),
                      ),
                    ],
                  ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
          _buildNavItem(Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.person_rounded, 'Profile', 1),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)])
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
                          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[400],
              size: 22,
            ),
            if (isSelected) ...[
                                SizedBox(width: 8),
              Text(
                label,
                                    style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                  ),
                                ),
                              ],
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: List.generate(3, (index) =>
          Container(
            margin: EdgeInsets.only(bottom: 16),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 20),
                            Text(
            'No nurses found',
                              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
                            Text(
            'Try adjusting your search criteria\nor check back later',
                              style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                  strokeWidth: 4,
                ),
              ),
              SizedBox(height: 30),
            Text(
                'Loading your healthcare dashboard...',
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

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  int _getAvailableNursesCount(NurseProvider provider) {
    if (provider.nurseModel?.Model == null) return 0;
    return provider.nurseModel!.Model
        .where((nurse) => nurse["approved"] == "Accepted")
        .length;
  }
}

class ModernNurseCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;
  final Map<String, dynamic> nurseData;
  final int patientData;
  final bool isOnline;

  const ModernNurseCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.nurseData,
    required this.patientData,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final nurseImageUrl = nurseData['profileImage'] ?? '';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 8),
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
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                            color: Color(0xFF667eea).withOpacity(0.3),
                            blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                        radius: 32,
                    backgroundColor: Colors.transparent,
                        backgroundImage: nurseImageUrl.isNotEmpty ? NetworkImage(nurseImageUrl) : null,
                        child: nurseImageUrl.isEmpty
                            ? Icon(Icons.person, color: Colors.white, size: 32)
                        : null,
                  ),
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          if (isOnline)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Online',
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        specialty,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFB020), Color(0xFFFF8C00)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFF4CAF50).withOpacity(0.1),
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
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF667eea).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF667eea),
                  size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}