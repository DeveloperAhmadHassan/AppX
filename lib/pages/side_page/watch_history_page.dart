import 'package:flutter/material.dart';

class WatchHistoryPage extends StatelessWidget {
  const WatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch History", style: TextStyle(
          color: Colors.white,
          fontSize: 18
        )),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
    );
  }
}
