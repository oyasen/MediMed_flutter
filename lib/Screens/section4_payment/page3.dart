import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:medimed/Screens/section4_payment/page4.dart';

import '../../Payment Method/payment_manager.dart';
import '../../Widgets/form_widget.dart';

class PaymentPage3 extends StatefulWidget {
  const PaymentPage3({super.key});

  @override
  State<PaymentPage3> createState() => _PaymentPage3State();
}

class _PaymentPage3State extends State<PaymentPage3> {
  TextEditingController priceCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Card",
          style: TextStyle(color: Color(0xff0299c6)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CreditCardWidget(
              cardNumber: "XXXX XXXX XXXX XXXX",
              expiryDate: "01/20",
              cardHolderName: "MediMed",
              cvvCode: "xxx",
              showBackView: false,
              onCreditCardWidgetChange: (CreditCardBrand brand) {},
              bankName: 'Name of the Bank',
              cardBgColor: Colors.yellow,
              glassmorphismConfig: Glassmorphism(
                blurX: 10.0,
                blurY: 10.0,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.grey.withAlpha(20),
                    Colors.white.withAlpha(20),
                  ],
                  stops: const <double>[0.3, 0],
                ),
              ),
              enableFloatingCard: true,
              floatingConfig: const FloatingConfig(
                isGlareEnabled: true,
                isShadowEnabled: true,
                shadowConfig: FloatingShadowConfig(
                  offset: Offset(10, 10),
                  color: Colors.blue,
                  blurRadius: 15,
                ),
              ),
              backgroundNetworkImage: 'https://www.xyz.com/card_bg.png',
              labelValidThru: 'VALID\nTHRU',
              obscureCardNumber: true,
              obscureInitialCardNumber: false,
              obscureCardCvv: true,
              labelCardHolder: 'CARD HOLDER',
              cardType: CardType.mastercard,
              isHolderNameVisible: true, // ✅ Ensure cardholder name is visible
              height: 175,
              textStyle: const TextStyle(color: Colors.black87),
              width: MediaQuery.of(context).size.width,
              isChipVisible: true,
              isSwipeGestureEnabled: true,
              animationDuration: const Duration(milliseconds: 1000),
              frontCardBorder: Border.all(color: Colors.black87),
              backCardBorder: Border.all(color: Colors.black87),
              chipColor: Colors.yellow[100],
              padding: 16,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 50, 19, 0),
              child: CustomFormField(
                controller: priceCont,
                label: 'Price',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 50, 19, 0),
              child: MaterialButton(
                onPressed: () async {
                  int amount = int.tryParse(priceCont.text) ?? 0;
                  bool isSuccess = await PaymentManager.makePayment(amount, "EGP");

                  if (isSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage4()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Payment failed. Please try again."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                color: const Color(0xff0299c6),
                child: const Text("Save Card"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}