import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:medimed/Widgets/custom_bottomnavigationbar.dart';

import 'nurse_profile2.dart';

class NurseProfileScreen1 extends StatefulWidget {
  final Map<String, dynamic> nurseData;
  final int patientData;

  const NurseProfileScreen1({super.key, required this.nurseData, required this.patientData});

  @override
  State<NurseProfileScreen1> createState() => _NurseProfileScreen1State();
}

class _NurseProfileScreen1State extends State<NurseProfileScreen1> {
  DateTime? _selectedDate;
  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {},
  );

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
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(widget.nurseData['idCard'] ?? 'https://via.placeholder.com/150'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.nurseData['fullName'] ?? 'Nurse Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(widget.nurseData['specialaization'] ?? 'Specialization'),
                      Text('${widget.nurseData['experienceYears'] ?? '0'} years of experience'),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text(widget.nurseData['rating']?.toString() ?? '4.5'),
                        ],
                      ),
                      Text(widget.nurseData['availability'] ?? 'Availability: Not specified'),
                      Text(widget.nurseData['bio'] ?? 'An experienced and compassionate nurse dedicated to providing high-quality patient care. Skilled in assisting medical teams and ensuring patient comfort.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  if (date.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                    // Show a warning if the user selects a past date
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("You cannot select a past date!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    setState(() {
                      _selectedDate = date;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentBooking(nurseData: widget.nurseData, patientData: widget.patientData),
                      ),
                    );
                  }
                },

                selectedDayButtonColor: Colors.blue,
                selectedDayBorderColor: Colors.blue,
                selectedDayTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(
                  color: Colors.red,
                ),
                thisMonthDayBorderColor: Colors.grey,
                markedDatesMap: _markedDateMap,
                height: 420.0,
                daysHaveCircularBorder: false,
              ),
              if (_selectedDate != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Selected Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}

class AppointmentBookingScreen extends StatelessWidget {
  final DateTime selectedDate;

  const AppointmentBookingScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Booking"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
