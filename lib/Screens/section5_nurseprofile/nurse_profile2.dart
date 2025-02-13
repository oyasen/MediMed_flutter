import 'package:flutter/material.dart';
import 'package:medimed/Screens/section5_nurseprofile/Requests.dart';
import 'package:medimed/Screens/section5_nurseprofile/nurse_profile3.dart';
import 'package:medimed/Widgets/custom_bottomnavigationbar.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() => NurseProfile2();
}

class NurseProfile2 extends State<AppointmentBookingScreen> {
  int _selectedIndex = -1;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<String> availableTimeSlots = [
    '''9:00AM - 
  12:00PM''',
    '''12:00PM - 
  3:00PM''',
    '''3:00PM - 
  6:00PM''',
    '''6:00PM - 
  9:00PM''',
    '''9:00PM - 
  12:00AM''',
    '''12:00AM - 
  3:00AM''',
    '''3:00AM - 
  6:00AM''',
    '''6:00AM - 
  9:00AM''',
  ];

  // Patient details form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male';
  final TextEditingController _problemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('N. Olivia Turner, M.D.'),
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
                          fontWeight: FontWeight.bold),
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
                            color: index == _selectedIndex
                                ? Colors.blue
                                : Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(availableTimeSlots[index])],
                            ),
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Patient Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                      ),
                    ),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: RadioListTile(
                          title: const Text('Male'),
                          value: 'Male',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                          child: RadioListTile(
                              title: const Text('Female'),
                              value: 'Female',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              }))
                    ]),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>RequestsPage() ,));
                      },
                      child: const Text("Save Data"),
                      color: const Color(0xff2196f3),
                    )
                  ]))),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
