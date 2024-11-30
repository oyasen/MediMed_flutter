import 'package:flutter/material.dart';
import 'package:medimed/Screens/section1/signup.dart';
import 'package:medimed/Screens/section4_payment/page1.dart';
import 'package:medimed/Screens/section5_nurseprofile/nurser_profile.dart';
import 'package:provider/provider.dart';

import 'Screens/section3_advice/healthadvice.dart';
import 'Screens/section5_nurseprofile/nurse_profile3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AppointmentDetailsScreen(),
    );
  }
}
