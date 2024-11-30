import 'package:flutter/material.dart';
import 'package:medimed/Screens/section2_questions/questionpage_3.dart';

void main() {
  runApp(const Questionpage2());
}

class Questionpage2 extends StatelessWidget {
  const Questionpage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediMed',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo.jpg",
                      width: 100,
                    ),
                    const Text(
                      'MediMed',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Hi, tell us about you, \nHow many medications\n do you take in the day??',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Questionpage3(),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFc9f1f4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text('From 1 to 5 medications'),
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Questionpage3(),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFc9f1f4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text('From 6 to 15 medications'),
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Questionpage3(),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFc9f1f4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text('From 15 to 20 medications'),
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Questionpage3(),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFc9f1f4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text('Other than that'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
