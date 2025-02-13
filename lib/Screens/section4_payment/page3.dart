import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:medimed/Screens/section4_payment/page4.dart';

class PaymentPage3 extends StatelessWidget {

  PaymentPage3({
    super.key,
  });

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
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CreditCardUi(
              cardHolderFullName: 'John Doe',
              cardNumber: '1234567812345678',
              validFrom: '01/23',
              validThru: '01/28',
              topLeftColor: Colors.blue,
              doesSupportNfc: true,
              placeNfcIconAtTheEnd: true,
              cardType: CardType.debit,
              cardProviderLogo: FlutterLogo(),
              cardProviderLogoPosition: CardProviderLogoPosition.right,
              showBalance: true,
              balance: 128.32434343,
              autoHideBalance: true,
              enableFlipping: true, // 👈 Enables the flipping
              cvvNumber: '123', // 👈 CVV number to be shown on the back of the card
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 50, 19, 0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage4(),
                      ));
                },
                color: const Color(0xff0299c6),
                child: const Text("Save Card"),
              ),
            )
          ],
        ),
      ),
    );
  }
}