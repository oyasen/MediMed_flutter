import 'package:flutter/material.dart';
import 'package:medimed/Screens/section2_questions/questionpage_3.dart';

void main() {
  runApp(const Questionpage3());
}

class Questionpage3 extends StatelessWidget {
  const Questionpage3({Key? key}) : super(key: key);

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
                  'How many consultations\n do you have in week??',
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
                    child: const Text('From 1 to 5 consultations'),
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
                    child: const Text('From 6 to 15 consultations'),
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
                    child: const Text('From 15 to 20 consultations'),
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
