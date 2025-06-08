import 'package:flutter/material.dart';
import 'package:medimed/Screens/Patient/section5_nurseprofile/success_book_page.dart';
import 'package:medimed/Widgets/custom_bottomnavigationbar.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';

class AppointmentBooking extends StatefulWidget {
  final Map<String, dynamic> nurseData;
  final int patientData;

  const AppointmentBooking({super.key, required this.nurseData, required this.patientData});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  int _selectedIndex = -1;

  List<String> availableTimeSlots = [
    '''9:00AM - 12:00PM''',
    '''12:00PM - 3:00PM''',
    '''3:00PM - 6:00PM''',
    '''6:00PM - 9:00PM''',
    '''9:00PM - 12:00AM''',
    '''12:00AM - 3:00AM''',
    '''3:00AM - 6:00AM''',
    '''6:00AM - 9:00AM''',
  ];


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NurseProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.nurseData['fullName'] ?? 'Nurse Name'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Available Time',
                style: TextStyle(
                  color: Color(0xff2196f3),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: availableTimeSlots.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: index == _selectedIndex ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          availableTimeSlots[index],
                          style: TextStyle(
                            color: index == _selectedIndex ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Patient Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),

              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () async {

                  int nurseId = widget.nurseData['id'];
                  await provider.getNurseById(nurseId);
                  int patientId = widget.patientData;


                  try {
                    await Provider.of<PatientProvider>(context, listen: false)
                        .addPatientsNurses(nurseId, patientId, "Processing");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nurse assigned successfully!")),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SuccessBookPage(status: "Processing", nurseName: provider.nurseGetModel!.Model["fullName"])),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
                },
                color: const Color(0xff2196f3),
                child: const Text("Save Data", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
