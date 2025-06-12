import 'package:flutter/material.dart';

import '../HomeScreen/home.dart';

class Appointment {
  final String patientName;
  final DateTime date;
  final String time;
  final String status;
  final String appointmentType;
  final String doctor;
  final String avatar;

  Appointment({
    required this.patientName,
    required this.date,
    required this.time,
    required this.status,
    required this.appointmentType,
    required this.doctor,
    required this.avatar,
  });
}

enum AppointmentFilter { upcoming, completed, cancelled }

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'All';
  AppointmentFilter selectedAppointmentFilter = AppointmentFilter.upcoming;

  List<Appointment> allAppointments = [
    Appointment(
      patientName: 'Ahmed Mohamed Ali',
      date: DateTime.now().add(Duration(days: 1)),
      time: '10:00 AM',
      status: 'Upcoming',
      appointmentType: 'Regular Checkup',
      doctor: 'Dr. Sarah Ahmed',
      avatar: 'A',
    ),
    Appointment(
      patientName: 'Fatima Hassan',
      date: DateTime.now(),
      time: '2:30 PM',
      status: 'Upcoming',
      appointmentType: 'Consultation',
      doctor: 'Dr. Mohamed Abdullah',
      avatar: 'F',
    ),
    Appointment(
      patientName: 'Khaled Abdelrahman',
      date: DateTime.now().add(Duration(days: 1)),
      time: '11:00 AM',
      status: 'Confirmed',
      appointmentType: 'Follow-up',
      doctor: 'Dr. Amira Salem',
      avatar: 'K',
    ),
    Appointment(
      patientName: 'Mariam Abdullah',
      date: DateTime.now().subtract(Duration(days: 1)),
      time: '9:00 AM',
      status: 'Completed',
      appointmentType: 'Regular Checkup',
      doctor: 'Dr. Ahmed Saleem',
      avatar: 'M',
    ),
    Appointment(
      patientName: 'Salma Hussein',
      date: DateTime.now().subtract(Duration(days: 1)),
      time: '3:00 PM',
      status: 'Cancelled',
      appointmentType: 'Regular Checkup',
      doctor: 'Dr. Karim Farouk',
      avatar: 'S',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedAppointmentFilter = AppointmentFilter.values[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Appointment> get filteredAppointments {
    // First filter by tab selection
    List<Appointment> tabFiltered = [];
    switch (selectedAppointmentFilter) {
      case AppointmentFilter.completed:
        tabFiltered = allAppointments.where((a) => a.status == 'Completed').toList();
        break;
      case AppointmentFilter.cancelled:
        tabFiltered = allAppointments.where((a) => a.status == 'Cancelled').toList();
        break;
      case AppointmentFilter.upcoming:
      default:
        tabFiltered = allAppointments.where((a) => a.status == 'Upcoming' || a.status == 'Confirmed').toList();
    }

    // Then filter by chip selection if needed
    if (selectedFilter == 'Today') {
      return tabFiltered.where((a) =>
      a.date.year == DateTime.now().year &&
          a.date.month == DateTime.now().month &&
          a.date.day == DateTime.now().day
      ).toList();
    } else if (selectedFilter == 'Tomorrow') {
      final tomorrow = DateTime.now().add(Duration(days: 1));
      return tabFiltered.where((a) =>
      a.date.year == tomorrow.year &&
          a.date.month == tomorrow.month &&
          a.date.day == tomorrow.day
      ).toList();
    } else if (selectedFilter == 'This Week') {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 6));
      return tabFiltered.where((a) =>
      a.date.isAfter(startOfWeek) && a.date.isBefore(endOfWeek)
      ).toList();
    }

    return tabFiltered;
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    return Container(
      margin: EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = label;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: Color(0xFF3B82F6).withOpacity(0.1),
        labelStyle: TextStyle(
          color: isSelected ? Color(0xFF3B82F6) : Color(0xFF64748B),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? Color(0xFF3B82F6) : Color(0xFFE2E8F0),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    Color statusColor;
    switch (appointment.status) {
      case 'Completed':
        statusColor = Color(0xFF10B981);
        break;
      case 'Cancelled':
        statusColor = Color(0xFFEF4444);
        break;
      case 'Confirmed':
        statusColor = Color(0xFF10B981);
        break;
      case 'Upcoming':
      default:
        statusColor = Color(0xFF3B82F6);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
                child: Text(
                  appointment.avatar,
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      appointment.appointmentType,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Color(0xFF64748B)),
              SizedBox(width: 4),
              Text(
                _formatDate(appointment.date),
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: Color(0xFF64748B)),
              SizedBox(width: 4),
              Text(
                appointment.time,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              Spacer(),
              Text(
                appointment.doctor,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (appointment.status == 'Upcoming' || appointment.status == 'Confirmed') ...[
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _updateAppointmentStatus(appointment, 'Cancelled');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFEF4444)),
                      foregroundColor: Color(0xFFEF4444),
                    ),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showRescheduleDialog(appointment);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Reschedule'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    final tomorrow = now.add(Duration(days: 1));
    if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  void _updateAppointmentStatus(Appointment appointment, String newStatus) {
    setState(() {
      allAppointments = allAppointments.map((a) {
        if (a.patientName == appointment.patientName &&
            a.date == appointment.date &&
            a.time == appointment.time) {
          return Appointment(
            patientName: a.patientName,
            date: a.date,
            time: a.time,
            status: newStatus,
            appointmentType: a.appointmentType,
            doctor: a.doctor,
            avatar: a.avatar,
          );
        }
        return a;
      }).toList();
    });
  }

  void _showRescheduleDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? newDate = appointment.date;
        String newTime = appointment.time;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reschedule Appointment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text('Patient: ${appointment.patientName}'),
                    subtitle: Text('Type: ${appointment.appointmentType}'),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: appointment.date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (selectedDate != null) {
                        newDate = selectedDate;
                      }
                    },
                    child: Text(
                      'Select New Date: ${_formatDate(newDate!)}',
                      style: TextStyle(color: Color(0xFF3B82F6)),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: int.parse(newTime.split(':')[0]),
                          minute: int.parse(newTime.split(':')[1].split(' ')[0]),
                        ),
                      );
                      if (selectedTime != null) {
                        newTime = '${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}';
                      }
                    },
                    child: Text(
                      'Select New Time: $newTime',
                      style: TextStyle(color: Color(0xFF3B82F6)),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFFEF4444)),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _updateAppointmentDateAndTime(appointment, newDate!, newTime);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Appointment rescheduled successfully')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Confirm'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateAppointmentDateAndTime(Appointment appointment, DateTime newDate, String newTime) {
    setState(() {
      allAppointments = allAppointments.map((a) {
        if (a.patientName == appointment.patientName &&
            a.date == appointment.date &&
            a.time == appointment.time) {
          return Appointment(
            patientName: a.patientName,
            date: newDate,
            time: newTime,
            status: a.status,
            appointmentType: a.appointmentType,
            doctor: a.doctor,
            avatar: a.avatar,
          );
        }
        return a;
      }).toList();
    });
  }

  void _showAddAppointmentDialog() {
    TextEditingController patientNameController = TextEditingController();
    TextEditingController appointmentTypeController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedTime = '10:00 AM';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add New Appointment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: patientNameController,
                    decoration: InputDecoration(
                      labelText: 'Patient Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: appointmentTypeController,
                    decoration: InputDecoration(
                      labelText: 'Appointment Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) {
                        selectedDate = date;
                      }
                    },
                    child: Text(
                      'Select Date: ${_formatDate(selectedDate)}',
                      style: TextStyle(color: Color(0xFF3B82F6)),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        selectedTime = '${time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
                      }
                    },
                    child: Text(
                      'Select Time: $selectedTime',
                      style: TextStyle(color: Color(0xFF3B82F6)),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFFEF4444)),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (patientNameController.text.isNotEmpty &&
                              appointmentTypeController.text.isNotEmpty) {
                            setState(() {
                              allAppointments.add(
                                Appointment(
                                  patientName: patientNameController.text,
                                  date: selectedDate,
                                  time: selectedTime,
                                  status: 'Upcoming',
                                  appointmentType: appointmentTypeController.text,
                                  doctor: 'Dr. New Doctor',
                                  avatar: patientNameController.text[0].toUpperCase(),
                                ),
                              );
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Appointment added successfully')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Add'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Appointments',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
          onPressed: () => Navigator.push(context , MaterialPageRoute(builder: (context) => Placeholder(),)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: Color(0xFF3B82F6)),
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Color(0xFF3B82F6),
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('Today',
                      allAppointments.where((a) =>
                      a.date.year == DateTime.now().year &&
                          a.date.month == DateTime.now().month &&
                          a.date.day == DateTime.now().day
                      ).length.toString(),
                      Color(0xFF3B82F6)),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('This Week',
                      allAppointments.where((a) {
                        final now = DateTime.now();
                        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
                        final endOfWeek = startOfWeek.add(Duration(days: 6));
                        return a.date.isAfter(startOfWeek) && a.date.isBefore(endOfWeek);
                      }).length.toString(),
                      Color(0xFF10B981)),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('This Month',
                      allAppointments.where((a) =>
                      a.date.year == DateTime.now().year &&
                          a.date.month == DateTime.now().month
                      ).length.toString(),
                      Color(0xFFF59E0B)),
                ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Today'),
                _buildFilterChip('Tomorrow'),
                _buildFilterChip('This Week'),
                _buildFilterChip('Completed'),
                _buildFilterChip('Cancelled'),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Color(0xFF3B82F6),
              unselectedLabelColor: Color(0xFF64748B),
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),

          // Appointment List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList(),
                _buildAppointmentList(),
                _buildAppointmentList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAppointmentDialog,
        backgroundColor: Color(0xFF3B82F6),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppointmentList() {
    if (filteredAppointments.isEmpty) {
      return Center(
        child: Text(
          'No appointments found',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: filteredAppointments.map((appointment) {
        return _buildAppointmentCard(appointment);
      }).toList(),
    );
  }
}