import 'package:flutter/material.dart';

class WatchHistoryPage extends StatelessWidget {
  const WatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch History", style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold
        )),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            watchHistoryItem("assets/thumbnails/a.jpg"),
            watchHistoryItem("assets/thumbnails/b.jpg"),
            watchHistoryItem("assets/thumbnails/c.jpg"),
            watchHistoryItem("assets/thumbnails/d.jpg"),
            watchHistoryItem("assets/thumbnails/a.jpg"),
            watchHistoryItem("assets/thumbnails/b.jpg"),
            watchHistoryItem("assets/thumbnails/c.jpg"),
            watchHistoryItem("assets/thumbnails/d.jpg")
          ],
        ),
      ),
    );
  }
  
  Widget watchHistoryItem(String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image, fit: BoxFit.cover,),
            ),
          ),
          SizedBox(width: 30,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Satisfying Pop 💥", style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),),
              Text("3 Days Ago", style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),),
              Text("1.2M Views", style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18
              ),)
            ],
          )
        ],
      ),
    );
  }
}
