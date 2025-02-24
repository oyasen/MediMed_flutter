import 'package:flutter/material.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';
import 'package:medimed/Screens/section5_nurseprofile/Request_details.dart';

class RequestsPage extends StatefulWidget {
  final int patientData;
  const RequestsPage({super.key, required this.patientData});

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PatientProvider>(context, listen: false)
          .getPatientsNurse(widget.patientData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Requests",
          style: TextStyle(
              color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          final nurseList = patientProvider.nurseModel?.Model ?? [];

          if (patientProvider.nurseModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (nurseList.isEmpty) {
            return const Center(child: Text("No nurses found"));
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: nurseList.length,
              itemBuilder: (context, index) {
                final nurse = nurseList[index];

                if (nurse["status"] == "Completed") {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            nurse: nurse["nurse"],
                            book: nurse,
                          ),
                        ),
                      );

                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(15),
                        border: selectedIndex == index
                            ? Border.all(color: Colors.blue, width: 5)
                            : null,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: nurse['nurse']['idCard'] != null &&
                              nurse['nurse']['idCard'].isNotEmpty
                              ? NetworkImage(nurse['nurse']['idCard'])
                              : const AssetImage('assets/nurse_placeholder.png')
                          as ImageProvider,
                        ),
                        title: Text(
                          nurse['nurse']['fullName'] ?? 'Unknown',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
