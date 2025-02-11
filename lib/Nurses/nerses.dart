import 'package:flutter/material.dart';
import 'package:medimed/Nurses/favorite.dart';
import 'package:medimed/Nurses/female.dart';
import 'package:medimed/Nurses/male.dart';
import 'package:medimed/Nurses/nurse_info.dart';
import 'package:medimed/Nurses/rating.dart';

class NursesPage extends StatelessWidget {
  final List<Map<String, String>> nurses = [
    {
      "name": "Dr. Alexander Bennett, Ph.D.",
      "specialty": "Dermato-Genetics",
      "image": "https://www.example.com/image1.jpg"
    },
    {
      "name": "Dr. Michael Davidson, M.D.",
      "specialty": "Solar Dermatology",
      "image": "https://www.example.com/image2.jpg"
    },
    {
      "name": "Dr. Olivia Turner, M.D.",
      "specialty": "Dermato-Endocrinology",
      "image": "https://www.example.com/image3.jpg"
    },
    {
      "name": "Dr. Sophia Martinez, Ph.D.",
      "specialty": "Cosmetic Bioengineering",
      "image": "https://www.example.com/image4.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Nurses",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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

              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: nurses.length,
                itemBuilder: (context, index) {
                  final nurse = nurses[index];
                  return Card(
                    color: Colors.blue.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(nurse["image"]!),
                      ),
                      title: Text(
                        nurse["name"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(nurse["specialty"]!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>NurseInfoPage() ,));

                            },
                            child: Text("Info"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            icon: Icon(Icons.calendar_today, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite_border, color: Colors.blue),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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