import 'package:flutter/material.dart';
import 'package:medimed/Screens/Nurse/info_page_nurse.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';
import 'PatientDetailsPage.dart';

class NurseHome extends StatefulWidget {
  final int? id;
  const NurseHome({super.key, required this.id});

  @override
  State<NurseHome> createState() => _NurseHomeState();
}

class _NurseHomeState extends State<NurseHome> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _notificationCount = 3;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final List<Widget> _screens = [
    Container(), // Placeholder will be replaced with patient list
    const Center(child: Text('Profile Screen', style: TextStyle(fontSize: 18))),
    const Center(child: Text('Settings Screen', style: TextStyle(fontSize: 18))),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Responsive breakpoints
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 768;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  // Get responsive padding
  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (_isDesktop(context)) return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    if (_isTablet(context)) return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }

  // Get responsive card margin
  EdgeInsets _getCardMargin(BuildContext context) {
    if (_isDesktop(context)) return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    if (_isTablet(context)) return const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
    return const EdgeInsets.only(bottom: 12);
  }

  // Get responsive grid columns
  int _getGridColumns(BuildContext context) {
    if (_isDesktop(context)) return 3;
    if (_isTablet(context)) return 2;
    return 1;
  }

  // Pull to refresh function
  Future<void> _onRefresh() async {
    try {
      var nurseProvider = Provider.of<NurseProvider>(context, listen: false);
      await Future.wait([
        // Simulate API calls - replace with actual provider methods
        Future.delayed(const Duration(milliseconds: 800)),
        // You can add actual refresh calls here:
        // nurseProvider.refreshNursePatients(widget.id!),
        // nurseProvider.refreshNurseById(nurseProvider.nurseAddModel!.id),
      ]);

      // Force rebuild of the provider data
      if (mounted) {
        nurseProvider.getNursePatients(widget.id!);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 8),
                Text('Data refreshed successfully'),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Failed to refresh data'),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var nurseProvider = Provider.of<NurseProvider>(context);
    nurseProvider.getNurseById(widget.id!);
    var nurse = nurseProvider.nurseGetModel;

    if (nurse == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[800]!, Colors.blue[50]!],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
                SizedBox(height: 20),
                Text(
                  'Loading...',
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

    if (nurse.Model["approved"] != "Accepted") {
      return InfoPageNurse(patient: nurse);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        color: Colors.blue[700],
        backgroundColor: Colors.white,
        strokeWidth: 3,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildResponsiveSliverAppBar(context),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _currentIndex == 0
                    ? _buildPatientList()
                    : Padding(
                  padding: _getResponsivePadding(context),
                  child: _screens[_currentIndex],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildResponsiveBottomNavigationBar(context),
    );
  }

  Widget _buildResponsiveSliverAppBar(BuildContext context) {
    final isTabletOrDesktop = _isTablet(context);

    return SliverAppBar(
      expandedHeight: isTabletOrDesktop ? 140 : 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.blue[800],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Patients',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTabletOrDesktop ? 24 : 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[900]!,
                Colors.blue[700]!,
                Colors.blue[500]!,
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: isTabletOrDesktop ? 24 : 12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: isTabletOrDesktop ? 28 : 24,
                  ),
                  onPressed: () {
                    _showNotificationSnackBar();
                    setState(() => _notificationCount = 0);
                  },
                ),
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTabletOrDesktop ? 12 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatientList() {
    return Consumer<NurseProvider>(
      builder: (context, value, child) {
        value.getNursePatients(widget.id!);
        if (value.patientsModel == null) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 3),
                  SizedBox(height: 16),
                  Text(
                    'Loading patients...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        var patients = value.patientsModel!.Model;

        if (patients.isEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: _getResponsivePadding(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: _isTablet(context) ? 100 : 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No Patients Yet',
                  style: TextStyle(
                    fontSize: _isTablet(context) ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pull down to refresh or wait for patient assignments',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _isTablet(context) ? 16 : 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientCountHeader(context, patients.length),
            _buildResponsivePatientGrid(context, patients),
            SizedBox(height: _isTablet(context) ? 120 : 100), // Bottom padding
          ],
        );
      },
    );
  }

  Widget _buildPatientCountHeader(BuildContext context, int patientCount) {
    final padding = _getResponsivePadding(context);
    final isTabletOrDesktop = _isTablet(context);

    return Container(
      margin: padding,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[25] ?? Colors.blue[50]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.people,
              color: Colors.blue[800],
              size: isTabletOrDesktop ? 28 : 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Patients',
                  style: TextStyle(
                    fontSize: isTabletOrDesktop ? 16 : 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$patientCount',
                  style: TextStyle(
                    fontSize: isTabletOrDesktop ? 32 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Active',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTabletOrDesktop ? 14 : 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsivePatientGrid(BuildContext context, List<dynamic> patients) {
    final padding = _getResponsivePadding(context);
    final columns = _getGridColumns(context);
    final isGrid = columns > 1;

    if (isGrid) {
      return Padding(
        padding: padding,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: _isDesktop(context) ? 3.0 : 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: patients.length,
          itemBuilder: (context, index) {
            var nurse = patients[index];
            var patientData = nurse['patient'];

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 100)),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(50 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: _buildPatientCard(nurse, patientData, context),
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: patients.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          var nurse = patients[index];
          var patientData = nurse['patient'];

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 100)),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(50 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: _buildPatientCard(nurse, patientData, context),
                ),
              );
            },
          );
        },
      );
    }
  }

  Widget _buildPatientCard(Map<String, dynamic> nurse, Map<String, dynamic> patientData, BuildContext context) {
    final isTabletOrDesktop = _isTablet(context);
    final avatarSize = isTabletOrDesktop ? 70.0 : 60.0;

    return Container(
      margin: _getCardMargin(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PatientDetailsPage(
                  nurseId: nurse['id'],
                  patientData: patientData,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  );
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(isTabletOrDesktop ? 20 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getStatusColor(nurse['status']).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.blue[100]!, Colors.blue[50]!],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: patientData['idCard'] != null
                        ? Image.network(
                      patientData['idCard']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultAvatar(context),
                    )
                        : _buildDefaultAvatar(context),
                  ),
                ),
                SizedBox(width: isTabletOrDesktop ? 20 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientData['fullName'] ?? "Unknown Patient",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTabletOrDesktop ? 18 : 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: isTabletOrDesktop ? 8 : 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTabletOrDesktop ? 16 : 12,
                          vertical: isTabletOrDesktop ? 6 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(nurse['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          nurse['status'] ?? 'Pending',
                          style: TextStyle(
                            color: _getStatusColor(nurse['status']),
                            fontSize: isTabletOrDesktop ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(isTabletOrDesktop ? 12 : 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue[700],
                    size: isTabletOrDesktop ? 20 : 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    final isTabletOrDesktop = _isTablet(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[200]!, Colors.blue[100]!],
        ),
      ),
      child: Icon(
        Icons.person,
        color: Colors.blue[700],
        size: isTabletOrDesktop ? 35 : 30,
      ),
    );
  }

  Widget _buildResponsiveBottomNavigationBar(BuildContext context) {
    final isTabletOrDesktop = _isTablet(context);
    final height = isTabletOrDesktop ? 85.0 : 75.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0, context),
          _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 1, context),
          _buildNavItem(Icons.settings_outlined, Icons.settings, 'Settings', 2, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, String label, int index, BuildContext context) {
    bool isActive = _currentIndex == index;
    final isTabletOrDesktop = _isTablet(context);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTabletOrDesktop ? 20 : 16,
              vertical: isTabletOrDesktop ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: Color.lerp(Colors.transparent, Colors.blue[50], value),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? filledIcon : outlinedIcon,
                  color: Color.lerp(Colors.grey[600], Colors.blue[700], value),
                  size: isTabletOrDesktop ? 28 : 24,
                ),
                SizedBox(height: isTabletOrDesktop ? 6 : 4),
                Text(
                  label,
                  style: TextStyle(
                    color: Color.lerp(Colors.grey[600], Colors.blue[700], value),
                    fontSize: isTabletOrDesktop ? 14 : 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green[600]!;
      case 'declined':
        return Colors.red[600]!;
      case 'processing':
        return Colors.orange[600]!;
      case 'active':
        return Colors.blue[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  void _showNotificationSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.notifications, color: Colors.white),
            SizedBox(width: 8),
            Text('Notifications cleared'),
          ],
        ),
        backgroundColor: Colors.blue[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}