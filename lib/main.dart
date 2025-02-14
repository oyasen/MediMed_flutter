import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:medimed/Nurses/favorite.dart';
import 'package:medimed/Nurses/rating.dart';
import 'package:medimed/Screens/Buttons.dart';
import 'package:medimed/Screens/HomeScreen/home.dart';
import 'package:medimed/Screens/section1/signup.dart';
import 'package:medimed/Screens/section4_payment/page1.dart';
import 'package:medimed/Screens/section4_payment/page3.dart';
import 'package:medimed/Screens/section5_nurseprofile/nurser_profile.dart';
import 'package:medimed/Screens/user_profile/my_profile.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';
import 'Payment Method/stripe_keys.dart';
import 'Screens/section3_advice/healthadvice.dart';
import 'Screens/section5_nurseprofile/nurse_profile3.dart';

void main() {
  Stripe.publishableKey=ApiKeys.publishableKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UploadProvider(),),
        ChangeNotifierProvider(create: (context) => NurseProvider(),),
        ChangeNotifierProvider(create: (context) => PatientProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ButtonPage(),
      ),
    );
  }
}
