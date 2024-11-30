import 'package:flutter/material.dart';
import 'package:medimed/Screens/section4_payment/page2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payment',
      home: PaymentPage1(),
    );
  }
}

class PaymentPage1 extends StatelessWidget {
  const PaymentPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff0299c6),
          title: const Text(
            'Payment',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$100.00',
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    '',
                  ),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('N. Olivia Turner, M.D.'),
                    SizedBox(height: 4.0),
                    Text('Internal Medicine'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Color(0xff0299c6),
              height: 10,
              thickness: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Data / Hour",
                  style: TextStyle(color: Color(0xff0299c6)),
                ),
                Text("March 24, year / 10.00AM")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Duration",
                  style: TextStyle(color: Color(0xff0299c6)),
                ),
                Text("30 Minutes")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking for",
                  style: TextStyle(color: Color(0xff0299c6)),
                ),
                Text("Another Person")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Color(0xff0299c6),
              height: 10,
              thickness: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Amount",
                  style: TextStyle(color: Color(0xff0299c6)),
                ),
                Text("\$100")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Duration",
                  style: TextStyle(color: Color(0xff0299c6)),
                ),
                Text("30 Minutes")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(color: Color(0xff0299c6)),
                ),
                Text("\$100")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Color(0xff0299c6),
              height: 10,
              thickness: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment Method",
                  style: TextStyle(color: Color(0xff0299c6)),
                ),
                Text("Options")
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage2(),
                      ));
                },
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xff0299c6))),
                child: const Text(
                  "Pay Now",
                  style: TextStyle(color: Colors.white),
                ))
          ]),
        ));
  }
}
