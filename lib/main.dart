import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:medimed/Screens/Buttons.dart';
import 'package:medimed/provider/adminprovider.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';
import 'Payment Method/stripe_keys.dart';

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
        ChangeNotifierProvider(create: (context) => PatientProvider(),),
        ChangeNotifierProvider(create: (context) => Adminprovider(),),
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