import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Widgets/custom_paymentoption.dart';

class PaymentPage2 extends StatefulWidget {
  const PaymentPage2({super.key});

  @override
  State<PaymentPage2> createState() => _PaymentPage2State();
}

class _PaymentPage2State extends State<PaymentPage2> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0299c6),
        title: const Text(
          'Payment Method',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Credit & Debit Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            PaymentOption(
              icon: FontAwesomeIcons.creditCard,
              title: 'Add New Card',
              isChecked: isChecked,
            ),
            const SizedBox(height: 24),
            const Text(
              'More Payment Option',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            PaymentOption(
              icon: Icons.payment,
              title: 'Insta Pay',
              isChecked: isChecked,
            ),
            const SizedBox(height: 8),
            PaymentOption(
              icon: Icons.attach_money,
              title: 'Vodafone Cash',
              isChecked: isChecked,
            ),
          ],
        ),
      ),
    );
  }
}
