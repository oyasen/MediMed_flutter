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

class _NurseHomeState extends State<NurseHome> {
  int _currentIndex = 0; // Home is default
  int _notificationCount = 3; // Dynamic notification count

  // Screens for bottom navigation
  final List<Widget> _screens = [
    const Placeholder(), // Will be replaced with patient list
    const Placeholder(), // Profile screen
    const Placeholder(), // Settings screen
  ];

  @override
  Widget build(BuildContext context) {
    var nurseProvider = Provider.of<NurseProvider>(context);
    nurseProvider.getNurseById(nurseProvider.nurseAddModel!.id);
    var nurse = nurseProvider.nurseGetModel;

    if (nurse == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (nurse.Model["approved"] != "Accepted") {
      return InfoPageNurse(patient: nurse);
    }

    // Patient List Screen (now part of home tab)
    Widget buildPatientList() {
      return Consumer<NurseProvider>(
        builder: (context, value, child) {
          value.getNursePatients(widget.id!);
          if (value.patientsModel == null) {
            return const Center(child: CircularProgressIndicator());
          }
          var patients = value.patientsModel!.Model;

          return ListView.separated(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            itemCount: patients.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              var nurse = patients[index];
              var patientData = nurse['patient'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientDetailsPage(
                            nurseId: widget.id!,
                            patientData: patientData,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue[50],
                      backgroundImage: patientData['idCard'] != null
                          ? NetworkImage(patientData['idCard']!)
                          : null,
                      child: patientData['idCard'] == null
                          ? Icon(Icons.person, color: Colors.blue[800])
                          : null,
                    ),
                    title: Text(
                      patientData['fullName'] ?? "Unknown",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Status: ${nurse['status'] ?? 'Pending'}",
                      style: TextStyle(
                        color: _getStatusColor(nurse['status']),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Patients',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[800],
        actions: [
          // Notification Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // TODO: Implement notifications screen
                  setState(() => _notificationCount = 0); // Clear notifications
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _currentIndex == 0 ? buildPatientList() : _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.person, 'Profile', 1),
            _buildNavItem(Icons.settings, 'Settings', 2),
          ],
        ),
      ),
    );
  }

  // Custom Navigation Item
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue[800] : Colors.grey[600],
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.blue[800] : Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Get status color
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'processing':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}