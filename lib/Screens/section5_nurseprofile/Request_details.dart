import 'package:flutter/material.dart';
import 'package:medimed/Models/nursesmodel.dart';
import 'package:medimed/Screens/section4_payment/page2.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';


class BookingPage extends StatelessWidget {
  var nurse;
  var book;
  BookingPage({super.key,required this.nurse,required this.book});

  @override
  Widget build(BuildContext context) {
    print(nurse);
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: nurse["idCard"] == null ? null: NetworkImage(nurse["idCard"]),
              ),
              const SizedBox(height: 20),
              _buildLabel('Booking For'),
              _buildTextField(nurse["fullName"]),
              _buildLabel('Phone Number'),
              _buildTextField(nurse["contact"]),
              _buildLabel('Price'),
              _buildTextField(book["price"]?? "0"),
              _buildLabel('Booking Time'),
              _buildTextField(book["bookTime"].toString().split("T").join(' ')),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('Accept', Colors.blue,context,nurse["id"],book["patientId"]),
                  _buildButton('Delete', Colors.red,context,nurse["id"],book["patientId"]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 10),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(var hintText) {
    hintText = hintText.toString();
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.lightBlue[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        hintText: hintText,
      ),
    );
  }

  Widget _buildButton(String text, Color color,BuildContext context,nurseId , patientId) {
    var provider = Provider.of<PatientProvider>(context, listen: false);
    return ElevatedButton(
      onPressed: () async{
        if(text == "Accepted")
          {
            await provider.updateNursePatient(nurseId: nurseId, patientId:patientId, status: "Accept");
            await provider.getPatientsNurse(nurseId);
            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage2(),));
          }
        else
          {
            await provider.deletePatientNurse(nurseId: nurseId, patientId: patientId);
            Navigator.pop(context);
          }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
