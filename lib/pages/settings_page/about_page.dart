import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String markdownContent = "";

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    String content = await rootBundle.loadString('assets/files/about.md');
    setState(() {
      markdownContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About", style: TextStyle(

            fontWeight: FontWeight.bold,
            fontSize: 18
        )),

      ),
      body: markdownContent.isNotEmpty
          ? SingleChildScrollView(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
        child: MarkdownBody(data: markdownContent, styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 14),
          h1: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 16),
          h2: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          h3: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          h1Padding: EdgeInsets.zero,
          pPadding: EdgeInsets.zero,
          h2Padding: EdgeInsets.zero,
          listBullet: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: WrapAlignment.spaceAround,
        )),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
