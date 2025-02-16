import 'package:flutter/material.dart';
import 'package:medimed/provider/nurseprovider.dart';
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
    var nurseProvider = Provider.of<NurseProvider>(context);
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
        builder: (context, patientProvider, child){
          if (patientProvider.nurseModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (patientProvider.nurseModel!.Model.isEmpty) {
            return const Center(child: Text("No nurses found"));
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: patientProvider.nurseModel!.Model.length,
              itemBuilder: (context, index) {
                final nurse = patientProvider.nurseModel!.Model[index];
                if(nurse["status"] == "Completed") {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookingPage(nurse: nurse["nurse"],
                                book: nurse,), // Replace with actual page
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
                          backgroundImage: nurse['nurse']['idCard'] != null
                              ? NetworkImage(nurse['nurse']['idCard'])
                              : const AssetImage('assets/nurse_placeholder.png')
                          as ImageProvider,
                        ),
                        title: Text(
                          nurse['nurse']['fullName'] ?? 'Unknown',
                          // Nurse name from API
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  );
                }
              },

            ),
          );
        },
      ),
    );
  }
}
