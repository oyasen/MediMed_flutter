import 'package:flutter/material.dart';

class PatientNotificationsPage extends StatefulWidget {
  final int? patientId;

  const PatientNotificationsPage({super.key, required this.patientId});

  @override
  State<PatientNotificationsPage> createState() => _PatientNotificationsPageState();
}

class _PatientNotificationsPageState extends State<PatientNotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildCustomAppBar(),

            // Tab Bar
            _buildTabBar(),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllNotifications(),
                  _buildAppointmentNotifications(),
                  _buildMedicalNotifications(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A2B5CE6),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1565C0), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: showSearch
                    ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search notifications...',
                      hintStyle: TextStyle(color: Color(0xFF7B8FA1)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF7B8FA1), size: 20),
                    ),
                  ),
                )
                    : const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  showSearch ? Icons.close : Icons.search,
                  color: const Color(0xFF1565C0),
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    showSearch = !showSearch;
                    if (!showSearch) searchQuery = '';
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Color(0xFF1565C0)),
                onPressed: () => _showOptionsMenu(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF1976D2),
        indicatorWeight: 3,
        labelColor: const Color(0xFF1976D2),
        unselectedLabelColor: const Color(0xFF7B8FA1),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Appointments'),
          Tab(text: 'Medical'),
        ],
      ),
    );
  }

  Widget _buildAllNotifications() {
    // Mock data for demonstration
    final notifications = _getMockNotifications();

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          if (searchQuery.isNotEmpty &&
              !notification['title'].toLowerCase().contains(searchQuery.toLowerCase()) &&
              !notification['message'].toLowerCase().contains(searchQuery.toLowerCase())) {
            return const SizedBox.shrink();
          }
          return _buildNotificationCard(notification, index);
        },
      ),
    );
  }

  Widget _buildAppointmentNotifications() {
    final notifications = _getMockNotifications()
        .where((n) => n['type'] == 'appointment')
        .toList();

    if (notifications.isEmpty) {
      return _buildEmptyState(message: 'No appointment notifications');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(notifications[index], index);
      },
    );
  }

  Widget _buildMedicalNotifications() {
    final notifications = _getMockNotifications()
        .where((n) => n['type'] == 'medical')
        .toList();

    if (notifications.isEmpty) {
      return _buildEmptyState(message: 'No medical notifications');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(notifications[index], index);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    final isUnread = notification['isUnread'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isUnread
            ? Border.all(color: const Color(0xFF2196F3), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _markAsRead(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification['type']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification['type']),
                  color: _getNotificationColor(notification['type']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2196F3),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (notification['priority'] == 'high')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4444).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'URGENT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4444),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({String message = 'No notifications yet'}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 64,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'When you have notifications,\nthey will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildBottomSheetItem(
              Icons.done_all,
              'Mark all as read',
                  () => _markAllAsRead(),
            ),
            _buildBottomSheetItem(
              Icons.settings,
              'Notification settings',
                  () => _openNotificationSettings(),
            ),
            _buildBottomSheetItem(
              Icons.delete_outline,
              'Clear all notifications',
                  () => _clearAllNotifications(),
              isDestructive: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1976D2),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'appointment':
        return Icons.event;
      case 'medical':
        return Icons.medical_services;
      case 'reminder':
        return Icons.alarm;
      case 'result':
        return Icons.assessment;
      case 'prescription':
        return Icons.local_pharmacy;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'appointment':
        return const Color(0xFF2196F3);
      case 'medical':
        return const Color(0xFF4CAF50);
      case 'reminder':
        return const Color(0xFFFF9800);
      case 'result':
        return const Color(0xFF9C27B0);
      case 'prescription':
        return const Color(0xFF00BCD4);
      default:
        return const Color(0xFF1976D2);
    }
  }

  List<Map<String, dynamic>> _getMockNotifications() {
    return [
      {
        'title': 'Appointment Reminder',
        'message': 'Your appointment with Dr. Sarah Johnson is tomorrow at 10:00 AM',
        'time': '2 hours ago',
        'type': 'Nurse',
        'isUnread': true,
        'priority': 'high',
      },


      {
        'title': 'Health Checkup Due',
        'message': 'It\'s been 6 months since your last checkup. Schedule your next visit.',
        'time': '2 days ago',
        'type': 'reminder',
        'isUnread': false,
        'priority': 'normal',
      },
      {
        'title': 'Vaccination Reminder',
        'message': 'Your annual flu vaccination is due. Book an appointment today.',
        'time': '3 days ago',
        'type': 'medical',
        'isUnread': false,
        'priority': 'normal',
      },
      {
        'title': 'Appointment Confirmed',
        'message': 'Your appointment on March 15th at 2:00 PM has been confirmed',
        'time': '1 week ago',
        'type': 'appointment',
        'isUnread': false,
        'priority': 'normal',
      },
    ];
  }

  void _markAsRead(int index) {
    // Implement mark as read functionality
    setState(() {
      // Update notification read status
    });
  }

  void _markAllAsRead() {
    // Implement mark all as read functionality
    setState(() {
      // Update all notifications read status
    });
  }

  void _openNotificationSettings() {
    // Navigate to notification settings
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsPage(),
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear All Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                // Clear all notifications
              });
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Notification Settings Page
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool appointmentNotifications = true;
  bool medicationReminders = true;
  bool labResults = true;
  bool healthTips = false;
  bool promotions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1565C0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: Color(0xFF1565C0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsCard([
            _buildSettingsItem(
              'Appointment Notifications',
              'Get notified about upcoming appointments',
              appointmentNotifications,
                  (value) => setState(() => appointmentNotifications = value),
            ),


            _buildSettingsItem(
              'Health Tips',
              'Weekly health tips and advice',
              healthTips,
                  (value) => setState(() => healthTips = value),
            ),
            _buildSettingsItem(
              'Promotions & Offers',
              'Special offers and promotional content',
              promotions,
                  (value) => setState(() => promotions = value),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }
}