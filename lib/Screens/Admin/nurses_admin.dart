import 'package:flutter/material.dart';
import 'package:medimed/Screens/Admin/nurse_details.dart';
import 'package:medimed/provider/adminprovider.dart';
import 'package:provider/provider.dart';


class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var adminprovider = Provider.of<Adminprovider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          const SizedBox(height: 10),
          ToggleButtonsWidget(),
          Expanded(
            child: Consumer(
              builder: (context, value, child) {
                var nurses = adminprovider.nurseModel;
                if(nurses == null)
                  {
                    adminprovider.getAllNurses();
                    return Center(child: CircularProgressIndicator(),);
                  }
                return ListView.builder(
                  itemCount: nurses.Model.length,
                  itemBuilder: (context, index) {
                    return NurseCard(nurse: nurses.Model[index]);
                  },
                );
              }
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class ToggleButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffe4f2f3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.teal),
      ),
      child: Row(
        children: [
          Expanded(child: ToggleButton(text: "Nurses", selected: true)),
          Expanded(child: ToggleButton(text: "Patients", selected: false)),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String text;
  final bool selected;

  ToggleButton({required this.text, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NurseCard extends StatelessWidget {
  final Map nurse;

  NurseCard({required this.nurse});

  @override
  Widget build(BuildContext context) {
    var adminProv = Provider.of<Adminprovider>(context, listen: false);
    Color statusColor;
    String statusText = nurse["approved"] == "Processing"
        ? "New User"
        : nurse["approved"] == "Accepted"
        ? "Done"
        : "Rejected";

    if (statusText == "New User") {
      statusColor = Colors.green;
    } else if (statusText == "Done") {
      statusColor = Colors.grey;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      color: Colors.blue[100],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(nurse["idCard"]),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 100,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nurse["fullName"],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(nurse["email"], style: TextStyle(color: Colors.black)),
                          Text(nurse["contact"], style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Container(
                    width: 75,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        statusText,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () async {
                var nurseDetails = await adminProv.getNurseById(nurse['id']); // Await the response
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NurseDetails(nurse: nurseDetails),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Details", style: TextStyle(color: Colors.white, fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}

