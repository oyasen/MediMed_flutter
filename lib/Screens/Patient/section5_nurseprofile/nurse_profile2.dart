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

class _AppointmentBookingState extends State<AppointmentBooking> with TickerProviderStateMixin {
  int _selectedIndex = -1;
  bool _isLoading = false;
  bool _hasDescription = false; // Add this state variable
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Description controller
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> availableTimeSlots = [
    {'time': '9:00AM - 12:00PM', 'period': 'Morning', 'icon': Icons.wb_sunny},
    {'time': '12:00PM - 3:00PM', 'period': 'Afternoon', 'icon': Icons.wb_sunny_outlined},
    {'time': '3:00PM - 6:00PM', 'period': 'Afternoon', 'icon': Icons.light_mode},
    {'time': '6:00PM - 9:00PM', 'period': 'Evening', 'icon': Icons.wb_twilight},
    {'time': '9:00PM - 12:00AM', 'period': 'Night', 'icon': Icons.nights_stay},
    {'time': '12:00AM - 3:00AM', 'period': 'Late Night', 'icon': Icons.bedtime},
    {'time': '3:00AM - 6:00AM', 'period': 'Early Morning', 'icon': Icons.brightness_2},
    {'time': '6:00AM - 9:00AM', 'period': 'Early Morning', 'icon': Icons.wb_sunny},
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    // Add listener to description controller
    _descriptionController.addListener(_onDescriptionChanged);

    _fadeController.forward();
    _slideController.forward();
  }

  // Add this method to handle description changes
  void _onDescriptionChanged() {
    final hasText = _descriptionController.text.trim().isNotEmpty;
    if (hasText != _hasDescription) {
      setState(() {
        _hasDescription = hasText;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _descriptionController.removeListener(_onDescriptionChanged); // Remove listener
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NurseProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Book Appointment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'with ${widget.nurseData['fullName'] ?? 'Nurse'}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nurse Info Card
                            _buildNurseInfoCard(),

                            const SizedBox(height: 30),

                            // Time Slots Section
                            _buildTimeSlotsSection(),

                            const SizedBox(height: 30),

                            // Description Section
                            _buildDescriptionSection(),

                            const SizedBox(height: 30),

                            // Book Appointment Button
                            _buildBookButton(provider),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildNurseInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.purple[50]!],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[100]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(
                    widget.nurseData['idCard'] ?? 'https://via.placeholder.com/150'
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nurseData['fullName'] ?? 'Nurse Name',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.medical_services, size: 16, color: Colors.blue[600]),
                    const SizedBox(width: 5),
                    Text(
                      widget.nurseData['specialaization'] ?? 'General Nursing',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[600]),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.nurseData['rating'] ?? '4.5'} • ${widget.nurseData['experienceYears'] ?? '5'} years exp.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.access_time, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Available Time Slots',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          'Choose your preferred time slot',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: availableTimeSlots.length,
          itemBuilder: (context, index) {
            final slot = availableTimeSlots[index];
            final isSelected = index == _selectedIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    )
                        : null,
                    color: isSelected ? null : Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey[300]!,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        slot['icon'],
                        color: isSelected ? Colors.white : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        slot['time'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF2D3748),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        slot['period'],
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey[500],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Describe Your Needs',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Please provide details about the care you need',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 5,
              minLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe the type of care needed, medical conditions, specific requirements, or any other relevant information...',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[600], size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This information helps the nurse prepare for your appointment and provide better care.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(NurseProvider provider) {
    // Use the state variable instead of checking the controller directly
    bool canBook = _selectedIndex != -1 && _hasDescription;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: canBook
            ? const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        )
            : null,
        color: !canBook ? Colors.grey[300] : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: canBook
            ? [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: !canBook || _isLoading ? null : () => _bookAppointment(provider),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _isLoading
                ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: canBook ? Colors.white : Colors.grey[600],
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  !canBook ? 'Complete Required Fields' : 'Book Appointment',
                  style: TextStyle(
                    color: canBook ? Colors.white : Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _bookAppointment(NurseProvider provider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      int nurseId = widget.nurseData['id'];
      await provider.getNurseById(nurseId);
      int patientId = widget.patientData;
      String description = _descriptionController.text.trim();

      await Provider.of<PatientProvider>(context, listen: false)
          .addPatientsNurses(nurseId, patientId, "Processing", description);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              const Text("Appointment booked successfully!"),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessBookPage(
            status: "Processing",
            nurseName: provider.nurseGetModel!.Model["fullName"],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text("Error: you are already in contact with this nurse.")),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF667eea).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF667eea) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF667eea) : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}