import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String markdownContent = "";

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    String content = await rootBundle.loadString('assets/files/privacy_policy.md');
    setState(() {
      markdownContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
        )),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: markdownContent.isNotEmpty
          ? SingleChildScrollView(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
        child: MarkdownBody(data: markdownContent, styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: TextStyle(color: Colors.white, fontSize: 16),
            h1: TextStyle(color: Colors.white),
            h2: TextStyle(color: Colors.white),
            h3: TextStyle(color: Colors.white),
            textAlign: WrapAlignment.spaceAround
        ),
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
