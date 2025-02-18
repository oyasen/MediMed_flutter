import 'package:flutter/material.dart';
import 'package:medimed/provider/adminprovider.dart';
import 'package:provider/provider.dart';


class NurseDetails extends StatelessWidget {
  Map nurse;
  TextEditingController message = TextEditingController();
  NurseDetails({required this.nurse});
  @override
  Widget build(BuildContext context) {
    var adminprovider = Provider.of<Adminprovider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Nurse Details")
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(nurse["idCard"]),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Full Name :', style: TextStyle(fontSize: 15, color: Colors.blue)),
                          Text(nurse["fullName"], style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Email :', style: TextStyle(fontSize: 15, color: Colors.blue)),
                          Text(nurse["email"], style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Birth Of Date :', style: TextStyle(fontSize: 15, color: Colors.blue)),
                          Text(nurse["dateOfBirth"], style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Phone :', style: TextStyle(fontSize: 15, color: Colors.blue)),
                          Text(nurse["contact"], style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Specialization :', style: TextStyle(fontSize: 15, color: Colors.blue)),
                          Text(nurse["specialization"], style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Gender :', style: TextStyle(fontSize: 15, color: Colors.blue)),
                          Text(nurse["gender"], style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildDocumentSection('Professional Practice License', nurse["professionalPracticeLicense"]),
              buildDocumentSection('Graduation Certificate', nurse["graduationCertificate"]),
              buildDocumentSection('Clinical Report And Identification', nurse["clinicalReportAndIdentification"]),
              buildDocumentSection('ID Card', nurse["idCard"]),
              SizedBox(height: 20),
              Text(
                'Add Comments (Optional):',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 5),
              TextField(
                controller: message,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      adminprovider.updateNurse(nurseId: nurse["id"], approved: true, message: message.text);
                      adminprovider.getAllNurses();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Approve',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      adminprovider.updateNurse(nurseId: nurse["id"], approved: false, message: message.text);
                      adminprovider.getAllNurses();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Reject',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDocumentSection(String title, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
        Image.asset(imagePath, height: 100, fit: BoxFit.cover),
        SizedBox(height: 20),
      ],
    );
  }
}

/*
Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() => isNursesSelected = true),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isNursesSelected ? Colors.lightBlue[100] : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.medical_services, size: 16, color: Colors.black),
                      SizedBox(width: 5),
                      Text('Nurses', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => isNursesSelected = false),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Patients', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
 */