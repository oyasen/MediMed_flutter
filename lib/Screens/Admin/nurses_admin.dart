import 'package:flutter/material.dart';
import 'package:medimed/Screens/Admin/nurse_details.dart';
import 'package:medimed/Screens/Admin/patient_admin.dart';
import 'package:medimed/provider/adminprovider.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = Provider.of<Adminprovider>(context, listen: false);
      if (adminProvider.nurseModel == null) {
        adminProvider.getAllNurses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var adminProvider = Provider.of<Adminprovider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7C4DFF), Color(0xFF6C63FF)],
            ),
          ),
        ),
        title: const Text(
          "Nurse Management",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
            ),
            onPressed: () {
              adminProvider.getAllNurses();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF7C4DFF), Color(0xFFF8F9FA)],
                stops: [0.0, 0.8],
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search nurses by name or email...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.search_rounded, color: Colors.grey[400], size: 24),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Chips
                Row(
                  children: [
                    const Text(
                      'Filter by Status:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'New User', 'Approved', 'Rejected'].map((filter) {
                            final isSelected = selectedFilter == filter;
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  filter,
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedFilter = filter;
                                  });
                                },
                                backgroundColor: Colors.white.withOpacity(0.2),
                                selectedColor: Colors.white,
                                checkmarkColor: const Color(0xFF7C4DFF),
                                side: BorderSide(
                                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nurses List
          Expanded(
            child: Consumer<Adminprovider>(
              builder: (context, value, child) {
                var nurses = adminProvider.nurseModel;
                if (nurses == null) {
                  adminProvider.getAllNurses();
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF7C4DFF),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading nurses...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter nurses based on search and filter
                var filteredNurses = nurses.Model.where((nurse) {
                  final matchesSearch = searchQuery.isEmpty ||
                      nurse["fullName"].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
                      nurse["email"].toString().toLowerCase().contains(searchQuery.toLowerCase());

                  final matchesFilter = selectedFilter == 'All' ||
                      _getStatusText(nurse["approved"]) == selectedFilter;

                  return matchesSearch && matchesFilter;
                }).toList();

                if (filteredNurses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No nurses found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filter criteria',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredNurses.length,
                  itemBuilder: (context, index) {
                    final originalIndex = nurses.Model.indexOf(filteredNurses[index]);
                    return NurseCard(
                      nurse: filteredNurses[index],
                      index: originalIndex,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const EnhancedBottomNavBar(),
    );
  }

  String _getStatusText(String? approved) {
    switch (approved) {
      case "Processing":
        return "New User";
      case "Accepted":
        return "Approved";
      case "Declined":
        return "Rejected";
      default:
        return "Rejected";
    }
  }
}

class EnhancedBottomNavBar extends StatelessWidget {
  const EnhancedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_rounded),
            label: "Nurses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: "Patients",
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PatientsPage(),
              ),
            );
          }
        },
      ),
    );
  }
}

class NurseCard extends StatelessWidget {
  final Map nurse;
  final int index;

  const NurseCard({super.key, required this.nurse, required this.index});

  @override
  Widget build(BuildContext context) {
    var adminProv = Provider.of<Adminprovider>(context, listen: false);

    String statusText = nurse["approved"] == "Processing"
        ? "New User"
        : nurse["approved"] == "Accepted"
        ? "Approved"
        : "Rejected";

    Color statusColor = _getStatusColor(statusText);
    IconData statusIcon = _getStatusIcon(statusText);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFAFAFF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Enhanced Profile Picture
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7C4DFF).withOpacity(0.2),
                        const Color(0xFF6C63FF).withOpacity(0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C4DFF).withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: nurse["idCard"] != null && nurse["idCard"].toString().isNotEmpty
                        ? NetworkImage(nurse["idCard"])
                        : null,
                    child: nurse["idCard"] == null || nurse["idCard"].toString().isEmpty
                        ? Icon(Icons.person_rounded, size: 32, color: Colors.grey[400])
                        : null,
                  ),
                ),
                const SizedBox(width: 16),

                // Nurse Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nurse["fullName"] ?? "Unknown Nurse",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.email_outlined, size: 16, color: Colors.grey[500]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              nurse["email"] ?? "No email",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone_outlined, size: 16, color: Colors.grey[500]),
                          const SizedBox(width: 6),
                          Text(
                            nurse["contact"] ?? "No phone",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (nurse["message"] != null && nurse["message"].toString().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.message_outlined, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                nurse["message"],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: const Color(0xFF7C4DFF).withOpacity(0.3),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NurseDetails(
                        nurse: adminProv.nurseModel!.Model[index],
                      ),
                    ),
                  );

                  if (result == true) {
                    adminProv.getAllNurses();
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "View Details",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "New User":
        return Colors.blue[600]!;
      case "Approved":
        return Colors.green[600]!;
      case "Rejected":
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "New User":
        return Icons.new_releases_rounded;
      case "Approved":
        return Icons.check_circle_rounded;
      case "Rejected":
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}
//Noorelain