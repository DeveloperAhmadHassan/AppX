import 'package:flutter/material.dart';
import 'package:heroapp/pages/discover_page/_components/discover_clicked_item.dart';

class DiscoverItemPage extends StatefulWidget {
  const DiscoverItemPage({super.key});

  @override
  State<DiscoverItemPage> createState() => _DiscoverItemPageState();
}

class _DiscoverItemPageState extends State<DiscoverItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trending", style: TextStyle(
        fontSize: 18
      )),foregroundColor: Colors.white, backgroundColor: Colors.black,),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            DiscoverClickedItem()
          ],
        ),
      ),
    );
  }
}
