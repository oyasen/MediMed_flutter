import 'package:flutter/material.dart';
import 'package:medimed/Screens/section1/signup.dart';
import 'package:medimed/Screens/section1/signup_nurse.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ButtonPage(),
    );
  }
}

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/landingAndLogo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 160),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupNurse(),));

                      },
                      color: Color(0xff0299c6),
                      elevation: 5,
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        width: 150,
                        height: 60,
                        child: Center(
                          child: Text(
                            "Nurse",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signup(),));
                      },
                      color: Colors.purple.shade800,
                      elevation: 5,
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        width: 150,
                        height: 60,
                        child: Center(
                          child: Text(
                            "Patient",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        ),
      );

  }

}
