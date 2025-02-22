import 'package:flutter/material.dart';
import 'package:medimed/provider/adminprovider.dart';
import 'package:provider/provider.dart';

class NurseDetails extends StatelessWidget {
  final Map nurse;
  final TextEditingController message = TextEditingController();

  NurseDetails({super.key, required this.nurse});

  @override
  Widget build(BuildContext context) {
    var adminprovider = Provider.of<Adminprovider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Nurse Details"),
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
                    backgroundImage: NetworkImage(nurse["idCard"] ?? ''),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow('Full Name :', nurse["fullName"]),
                      buildInfoRow('Email :', nurse["email"]),
                      buildInfoRow('Birth Of Date :', nurse["dateOfBirth"]),
                      buildInfoRow('Phone :', nurse["contact"]),
                      buildInfoRow('Specialization :', nurse["specialaization"]),
                      buildInfoRow('Gender :', nurse["gender"]),
                      buildInfoRow('Location :', nurse["location"]),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildDocumentSection('Professional Practice License', nurse["professionalPracticeLicense"]),
              buildDocumentSection('Graduation Certificate', nurse["graduationCertificate"]),
              buildDocumentSection('Clinical Report And Identification', nurse["criminalRecordAndIdentification"]),
              buildDocumentSection('ID Card', nurse["idCard"]),
              buildDocumentSection('Picture', nurse["personalPicture"]),
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
                    onPressed: () async {
                      await adminprovider.updateNurse(
                        nurseId: nurse["id"],
                        approved: true,
                        message: message.text,
                      );

                      print("Update successful, refreshing...");

                      await adminprovider.getAllNurses(); // Refresh nurses before popping
                      if (context.mounted) {
                        Navigator.pop(context, true); // Pass `true` as a result to indicate data changed
                      }
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
                    onPressed: () async {
                      await adminprovider.updateNurse(
                        nurseId: nurse["id"],
                        approved: false,
                        message: message.text,
                      );

                      print("Update successful, refreshing...");

                      await adminprovider.getAllNurses(); // Refresh nurses before popping
                      if (context.mounted) {
                        Navigator.pop(context, true); // Pass `true` as a result to indicate data changed
                      }
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

  Widget buildInfoRow(String label, dynamic value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 15, color: Colors.blue)),
        Text(value?.toString() ?? "N/A", style: TextStyle(fontSize: 15)),
      ],
    );
  }

  Widget buildDocumentSection(String title, dynamic imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
        imagePath != null && imagePath.toString().isNotEmpty
            ? Image.network(
          imagePath,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Text("Failed to load image");
          },
        )
            : Text("No image available"),
        SizedBox(height: 20),
      ],
    );
  }

}
