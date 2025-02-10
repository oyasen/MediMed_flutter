import 'package:flutter/material.dart';
import 'package:medimed/Nurses/favorite.dart';
import 'package:medimed/Nurses/female.dart';
import 'package:medimed/Nurses/nurse_info.dart';
import 'package:medimed/Nurses/rating.dart';

class MalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Male",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RatingPage(),));
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.star_border, color: Colors.blue,),
                    radius: 15,),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage(),));

                  },
                  child: CircleAvatar(child: Icon(Icons.favorite_border, color: Colors.blue),
                    radius: 15,),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FemalePage(),));

                  },
                  child: CircleAvatar(child: Icon(Icons.female, color: Colors.blue),
                    radius: 15,),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MalePage(),));
                  },
                  child: CircleAvatar(child: Icon(Icons.male, color: Colors.blue),
                    radius: 15,),
                ),

              ],
            ),
            SizedBox(height: 10),
            NurseCard(
              imageUrl: "https://www.example.com/image1.jpg",
              name: "N. Alexander Bennett, Ph.D.",
              specialty: "Dermato-Genetics",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image2.jpg",
              name: "N. Michael Davidson, M.D.",
              specialty: "Solar Dermatology",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image1.jpg",
              name: "N. Alexander Bennett, Ph.D.",
              specialty: "Dermato-Genetics",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image2.jpg",
              name: "N. Michael Davidson, M.D.",
              specialty: "Solar Dermatology",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image1.jpg",
              name: "N. Alexander Bennett, Ph.D.",
              specialty: "Dermato-Genetics",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image2.jpg",
              name: "N. Michael Davidson, M.D.",
              specialty: "Solar Dermatology",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image1.jpg",
              name: "N. Alexander Bennett, Ph.D.",
              specialty: "Dermato-Genetics",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image2.jpg",
              name: "N. Michael Davidson, M.D.",
              specialty: "Solar Dermatology",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
        ],
      ),
    );
  }
}

class NurseCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String specialty;

  NurseCard({
    required this.imageUrl,
    required this.name,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(specialty),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>NurseInfoPage() ,));

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Info", style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 10),
                      Icon(Icons.favorite_border, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}