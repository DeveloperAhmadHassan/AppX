import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories", style: TextStyle(
            color: Colors.white,
            fontSize: 18
        )),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
    );
  }
}
