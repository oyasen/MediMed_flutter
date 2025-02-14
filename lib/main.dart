import 'package:flutter/material.dart';
import 'package:medimed/Screens/Buttons.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';

void main() {
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
