import 'package:flutter/material.dart';
import 'package:medimed/Recommendations/Nurses/nerses.dart';
import 'package:medimed/Screens/Admin/patient_details.dart';
import 'package:provider/provider.dart';
import '../../provider/adminprovider.dart';
import 'nurses_admin.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  String searchQuery = '';
  String selectedFilter = 'All';

  // Pull-to-refresh function
  Future<void> _refreshPatients() async {
    final adminProvider = Provider.of<Adminprovider>(context, listen: false);
    await adminProvider.getAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    var adminprovider = Provider.of<Adminprovider>(context);
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
          "Patient Management",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
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
                      hintText: 'Search patients by name or email...',
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

          // Patients List with RefreshIndicator
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF7C4DFF),
              backgroundColor: Colors.white,
              strokeWidth: 3,
              displacement: 40,
              onRefresh: _refreshPatients,
              child: Consumer<Adminprovider>(
                builder: (context, value, child) {
                  var patients = adminprovider.patientsModel;
                  if (patients == null) {
                    adminprovider.getAllPatients();
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
                            'Loading patients...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Filter patients based on search and filter
                  var filteredPatients = patients.Model.where((patient) {
                    final matchesSearch = searchQuery.isEmpty ||
                        patient["fullName"].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
                        patient["email"].toString().toLowerCase().contains(searchQuery.toLowerCase());

                    final matchesFilter = selectedFilter == 'All' ||
                        _getStatusText(patient["approved"]) == selectedFilter;

                    return matchesSearch && matchesFilter;
                  }).toList();

                  if (filteredPatients.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                        Center(
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
                                'No patients found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pull down to refresh or try adjusting your search',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final originalIndex = patients.Model.indexOf(filteredPatients[index]);
                      return PatientCard(
                        patient: filteredPatients[index],
                        index: originalIndex,
                      );
                    },
                  );
                },
              ),
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SchedulePage(),
              ),
            );
          }
        },
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final Map patient;
  final int index;

  const PatientCard({super.key, required this.patient, required this.index});

  @override
  Widget build(BuildContext context) {
    var adminProv = Provider.of<Adminprovider>(context, listen: false);

    String statusText = patient["approved"] == "Processing"
        ? "New User"
        : patient["approved"] == "Accepted"
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
                    backgroundImage: patient["idCard"] != null && patient["idCard"].toString().isNotEmpty
                        ? NetworkImage(patient["idCard"])
                        : null,
                    child: patient["idCard"] == null || patient["idCard"].toString().isEmpty
                        ? Icon(Icons.person_rounded, size: 32, color: Colors.grey[400])
                        : null,
                  ),
                ),
                const SizedBox(width: 16),

                // Patient Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient["fullName"] ?? "Unknown Patient",
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
                              patient["email"] ?? "No email",
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
                          Expanded(
                            child: Text(
                              patient["contact"] ?? "No phone",
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
                      if (patient["message"] != null && patient["message"].toString().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.message_outlined, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                patient["message"],
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
                      builder: (context) => PatientDetails(
                          patient: adminProv.patientsModel!.Model[index]
                      ),
                    ),
                  );

                  if (result == true) {
                    adminProv.getAllPatients();
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

// Keeping the unused PatientCard class for reference
class PatientCardAlternative extends StatelessWidget {
  final Map patient;

  const PatientCardAlternative({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF0FFF4)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[100],
            backgroundImage: patient["idCard"] != null
                ? NetworkImage(patient["idCard"])
                : null,
            child: patient["idCard"] == null
                ? Icon(Icons.person_rounded, color: Colors.grey[400])
                : null,
          ),
        ),
        title: Text(
          patient["fullName"] ?? "Unknown Patient",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF2D3748),
          ),
        ),
        subtitle: Text(
          patient["email"] ?? "No email provided",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey[400],
          size: 16,
        ),
      ),
    );
  }
}
//Noorelain