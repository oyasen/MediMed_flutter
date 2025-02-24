import 'package:flutter/material.dart';
import 'package:medimed/Screens/section4_payment/page2.dart';
import 'package:medimed/Widgets/custom_bottomnavigationbar.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('N. Olivia Turner, M.D.'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(""),
            ),
            const SizedBox(
              height: 150,
            ),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Full name" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                  Text("john Doe" , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold))],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
             SizedBox(
               width: 300,
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Age",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold)), Text("25",style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold))],
                           ),
             ),
            const SizedBox(
              height: 30,
            ),
             SizedBox(
               width: 300,
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Gender",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold)),
                  Text("Male",style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold))],
                           ),
             ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage2(price: 0,),));
            },
              color: Color(0xFF0299C6),
              child: Text("Payment", style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold) ,),
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
