import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/assets.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String markdownContent = "";

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    String content = await rootBundle.loadString(Assets.filesPrivacyPolicy);
    setState(() {
      markdownContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy", style: TextStyle(
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
            textAlign: WrapAlignment.spaceAround
        ),
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
