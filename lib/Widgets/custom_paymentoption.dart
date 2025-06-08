import 'package:flutter/material.dart';
import 'package:medimed/Screens/Patient/section4_payment/page3.dart';
// import 'package:medimed/Screens/section4_payment/page3.dart';

class PaymentOption extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isChecked;
  final nurse;
  final price;
  const PaymentOption({
    super.key,
    required this.icon,
    required this.title,
    required this.isChecked, required this.price, this.nurse,
  });

  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: Colors.teal),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isChecked = !isChecked;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage3(
                        price: widget.price,
                        nurse: widget.nurse,
                      ),
                    ));
              });
            },
            child: Icon(
              isChecked
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
