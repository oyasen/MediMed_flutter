import 'package:flutter/material.dart';
import 'package:medimed/Nurses/favorite.dart';
import 'package:medimed/Nurses/female.dart';
import 'package:medimed/Nurses/male.dart';
import 'package:medimed/Nurses/nurse_info.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Rating",
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
                    radius: 15,
                    child: Icon(Icons.star_border, color: Colors.blue,),),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage(),));

                  },
                  child: CircleAvatar(radius: 15,child: Icon(Icons.favorite_border, color: Colors.blue),),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FemalePage(),));

                  },
                  child: CircleAvatar(radius: 15,child: Icon(Icons.female, color: Colors.blue),),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MalePage(),));
                  },
                  child: CircleAvatar(radius: 15,child: Icon(Icons.male, color: Colors.blue),),
                ),

              ],
            ),
            SizedBox(height: 10),
            NurseCard(
              imageUrl: "https://www.example.com/image1.jpg",
              name: "N. Olivia Turner, M.D.",
              specialty: "Dermato-Endocrinology",
              rating: "5",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image2.jpg",
              name: "N. Alexander Bennett, Ph.D.",
              specialty: "Dermato-Genetics",
              rating: "5",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image3.jpg",
              name: "N. Sophia Martinez, Ph.D.",
              specialty: "Cosmetic Bioengineering",
              rating: "4.9",
            ),
            NurseCard(
              imageUrl: "https://www.example.com/image4.jpg",
              name: "N. Michael Davidson, M.D.",
              specialty: "Solar Dermatology",
              rating: "4.8",
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
  final String rating;

  const NurseCard({super.key, 
    required this.imageUrl,
    required this.name,
    required this.specialty,
    required this.rating,
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
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.blue),
                      SizedBox(width: 5),
                      Text("Professional Nurse", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(specialty),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text(" $rating"),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>NurseInfoPage() ,));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Info"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}