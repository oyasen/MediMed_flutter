import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  final String name;
  final String rate;
  final String add;
  final String spec;
  final String experience;
  final dynamic price;
  final dynamic availableTime;
  final String nextAvailable;
  final String languages;
  final String type;
  final dynamic reviews;

  ProfilePage({required this.name , required this.price,required this.add,required this.availableTime,required this.experience,
    required this.rate,required this.spec ,required this.type,required this.reviews,required this.languages,required this.nextAvailable });
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1565C0),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/doctor.png'),
            ),
            SizedBox(height: 16),
            Text("$name", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Family Medicine', style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text('$rate ($reviews)')
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            InfoTile(icon: Icons.language, label: 'Languages', value: languages),
            InfoTile(icon: Icons.check_circle_outline, label: 'Available Today', value: '$availableTime ✅'),
            InfoTile(icon: Icons.location_on, label: 'Address', value: add),
            SizedBox(height: 16),
            //  Text('Contact Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ContactIcon(icon: Icons.call, label: 'Call'),
            //     ContactIcon(icon: Icons.message, label: 'Message'),
            //     ContactIcon(icon: Icons.video_call, label: 'Video Call'),
            //   ],
            // ),
            SizedBox(height: 16),
            Divider(),
            InfoTile(icon: Icons.work_outline, label: 'Years of Experience', value: experience),
            InfoTile(icon: Icons.local_hospital, label: 'Clinic', value: 'Al Shifa Medical Center'),
            InfoTile(
              icon: Icons.medical_services,
              label: 'Subspecialties',
              value: spec,
            ),
            SizedBox(height: 16),
            Divider(),
            Text('Appointments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            InfoTile(icon: Icons.today, label: 'Today', value: '5:00 PM - 9:00 PM'),
            InfoTile(icon: Icons.calendar_today, label: 'Tomorrow', value:nextAvailable),
            SizedBox(height: 16),
            Divider(),
            Text('Points & Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            InfoTile(icon: Icons.health_and_safety, label: 'General Health Points', value: '85'),
            InfoTile(icon: Icons.card_giftcard, label: 'Reward Points', value: '120'),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF1565C0)),
          SizedBox(width: 12),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value))
        ],
      ),
    );
  }
}

class ContactIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const ContactIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFF1976D2),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(label)
      ],
    );
  }
}