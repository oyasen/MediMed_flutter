import 'package:flutter/material.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';
import '../../Nurse/PatientDetailsPage.dart';
import '../../Nurse/info_page_nurse.dart';

class NotificationsPage extends StatefulWidget {
  final int id;

  const NotificationsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = true;
  List<dynamic> _filteredPatients = [];
  Map<int, dynamic> _patientDetails = {}; // Cache for patient details
  String _selectedFilter = 'All';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoadingPatientDetails = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadPatients();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    try {
      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      await patientProvider.getPatientsNurse(widget.id);

      if (mounted && patientProvider.patientsNurse?.Model != null) {
        // Load patient details for each patient-nurse relationship
        await _loadAllPatientDetails(patientProvider.patientsNurse!.Model);

        setState(() {
          _isLoading = false;
        });
        _animationController.forward();
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load patients. Please try again.');
      }
    }
  }

  Future<void> _loadAllPatientDetails(List<dynamic> patientNurseList) async {
    try {
      setState(() {
        _isLoadingPatientDetails = true;
      });

      final patientProvider = Provider.of<PatientProvider>(context, listen: false);

      // Extract unique patient IDs from the patient-nurse relationships
      Set<int> patientIds = {};
      for (var patientNurse in patientNurseList) {
        final patientId = patientNurse['patientId'];
        if (patientId != null) {
          patientIds.add(patientId);
        }
      }

      // Fetch patient details for each unique patient ID
      for (int patientId in patientIds) {
        if (!_patientDetails.containsKey(patientId)) {
          try {
            await patientProvider.getPatientById(patientId);
            if (patientProvider.patientModel != null) {
              _patientDetails[patientId] = patientProvider.patientModel;
            }
          } catch (e) {
            print('Failed to load patient details for ID $patientId: $e');
          }
        }
      }

      if (mounted) {
        setState(() {
          _isLoadingPatientDetails = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoadingPatientDetails = false;
        });
        _showErrorSnackBar('Failed to load some patient details.');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _filterAndSearchPatients(List<dynamic> allPatients) {
    setState(() {
      List<dynamic> filtered = allPatients;

      // Apply status filter
      if (_selectedFilter != 'All') {
        filtered = filtered
            .where((patient) => patient["status"] == _selectedFilter)
            .toList();
      }

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        filtered = filtered.where((patient) {
          // Get patient details from cache using patientId
          final patientId = patient['patientId'];
          final patientData = _patientDetails[patientId];

          final name = (patientData?['fullName'] ?? '').toLowerCase();
          final phone = (patientData?['phone'] ?? '').toLowerCase();
          final status = (patient['status'] ?? '').toLowerCase();
          final query = _searchQuery.toLowerCase();

          return name.contains(query) ||
              phone.contains(query) ||
              status.contains(query);
        }).toList();
      }

      _filteredPatients = filtered;
    });
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search patients...',
          prefixIcon: Icon(Icons.search, color: Colors.blue.shade600),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Completed', 'Pending', 'In Progress'];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: FilterChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                selectedColor: Colors.blue.shade600,
                backgroundColor: Colors.blue.shade50,
                side: BorderSide(
                  color: isSelected ? Colors.blue.shade600 : Colors.blue.shade200,
                ),
                elevation: isSelected ? 4 : 0,
                shadowColor: Colors.blue.shade200,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPatientCard(dynamic nurse, int index) {
    final patientId = nurse['patientId'];
    final patientData = _patientDetails[patientId];
    final statusColor = _getStatusColor(nurse['status']);

    // Show loading card if patient details are not loaded yet
    if (patientData == null) {
      return _buildLoadingPatientCard(index);
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          (index * 0.1).clamp(0.0, 1.0),
          ((index * 0.1) + 0.3).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      )),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Card(
          elevation: 6,
          shadowColor: Colors.blue.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _navigateToPatientDetails(nurse, patientData),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  _buildPatientAvatar(patientData),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPatientInfo(patientData, nurse)),
                  _buildArrowIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingPatientCard(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 6,
        shadowColor: Colors.blue.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Loading avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Loading name
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Loading status
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_horiz,
                  size: 14,
                  color: Colors.blue.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientAvatar(dynamic patientData) {
    return Hero(
      tag: 'patient_${patientData['id'] ?? DateTime.now().millisecondsSinceEpoch}',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundImage: patientData['idCard'] != null
              ? NetworkImage(patientData['idCard'])
              : null,
          radius: 30,
          backgroundColor: Colors.blue.shade100,
          child: patientData['idCard'] == null
              ? Icon(
            Icons.person,
            size: 24,
            color: Colors.blue.shade600,
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildPatientInfo(dynamic patientData, dynamic nurse) {
    final statusColor = _getStatusColor(nurse['status']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          patientData['fullName'] ?? "Unknown Patient",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey.shade800,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                nurse['status'] ?? 'Unknown',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (patientData['phone'] != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  patientData['phone'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildArrowIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.blue.shade600,
      ),
    );
  }

  void _navigateToPatientDetails(dynamic nurse, dynamic patientData) {
    // Create a combined object with both nurse and patient data
    final combinedData = {
      ...nurse,
      'patient': patientData,
    };

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PatientDetailsPage(patientNurseData: nurse),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green.shade600;
      case 'pending':
        return Colors.orange.shade600;
      case 'in progress':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _searchQuery.isNotEmpty
                      ? Icons.search_off
                      : Icons.notifications_off_outlined,
                  size: 64,
                  color: Colors.blue.shade300,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No results found'
                    : 'No notifications available',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Try adjusting your search or filters'
                    : 'Check back later for updates',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _selectedFilter = 'All';
                    });
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            _isLoadingPatientDetails
                ? 'Loading patient details...'
                : 'Loading notifications...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Expanded(
            child: Text(
              'Notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade600,
                Colors.blue.shade800,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<PatientProvider>(
                    builder: (context, patientProvider, child) {
                      if (_isLoading || _isLoadingPatientDetails) {
                        return _buildLoadingState();
                      }

                      if (patientProvider.patientsNurse?.Model == null) {
                        return _buildEmptyState();
                      }

                      final allPatients = patientProvider.patientsNurse!.Model;

                      // Apply filters and search
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _filterAndSearchPatients(allPatients);
                      });

                      return Column(
                        children: [
                          _buildSearchBar(),
                          _buildFilterChips(),
                          Expanded(
                            child: _filteredPatients.isEmpty
                                ? _buildEmptyState()
                                : RefreshIndicator(
                              onRefresh: _loadPatients,
                              color: Colors.blue.shade600,
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 20,
                                ),
                                itemCount: _filteredPatients.length,
                                itemBuilder: (context, index) {
                                  return _buildPatientCard(
                                    _filteredPatients[index],
                                    index,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
}