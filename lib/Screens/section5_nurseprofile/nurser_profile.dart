import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:medimed/Widgets/custom_bottomnavigationbar.dart';

import 'nurse_profile2.dart';

class NurseProfileScreen1 extends StatefulWidget {
  const NurseProfileScreen1({super.key});

  @override
  State<NurseProfileScreen1> createState() => _NurseProfileScreen1State();
}

class _NurseProfileScreen1State extends State<NurseProfileScreen1> {
  List<DateTime> _selectedDates = [];
  EventList<Event> _markedDateMap = EventList<Event>(
    events: {},
  );

  void _clearSelectedDates() {
    setState(() {
      _selectedDates.clear();
    });
  }

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
              const Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'N. Olivia Turner, M.D.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Dermato-Endocrinology'),
                      Text('20 years of experience'),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text('4.5'),
                        ],
                      ),
                      Text('Mon-Sat, 9 AM - 4 PM'),
                      Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  setState(() {
                    int index = _selectedDates.indexOf(date);
                    if (index != -1) {
                      _selectedDates.removeAt(index);
                    } else {
                      _selectedDates.add(date);
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentBookingScreen(),
                        ));
                  });
                },
                selectedDayButtonColor: Colors.blue,
                selectedDayBorderColor: Colors.blue,
                selectedDayTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(
                  color: Colors.red,
                ),
                thisMonthDayBorderColor: Colors.grey,
                customDayBuilder: (
                  bool isSelectable,
                  int index,
                  bool isSelectedDay,
                  bool isToday,
                  bool isPrevMonthDay,
                  TextStyle textStyle,
                  bool isNextMonthDay,
                  bool isThisMonthDay,
                  DateTime day,
                ) {
                  int selectedIndex = _selectedDates.indexOf(day);
                  if (selectedIndex != -1) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (selectedIndex + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return null;
                  }
                },
                weekFormat: false,
                markedDatesMap: _markedDateMap,
                height: 420.0,
                daysHaveCircularBorder: false,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearSelectedDates,
        child: Icon(Icons.refresh),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
