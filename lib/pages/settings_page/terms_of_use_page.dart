import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/assets.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({super.key});

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  String markdownContent = "";

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    String content = await rootBundle.loadString(Assets.filesTermsAndConditions);
    setState(() {
      markdownContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,size: 34,),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: markdownContent.isNotEmpty
          ? SingleChildScrollView(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
            child: MarkdownBody(data: markdownContent, styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 14, fontFamily: 'Outfit'),
              h1: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 36, fontFamily: 'Outfit'),
              h2: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 28, fontFamily: 'Outfit'),
              h3: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 24, fontFamily: 'Outfit'),
              textAlign: WrapAlignment.spaceAround
            )),
          ) : Center(child: CircularProgressIndicator()),
    );
  }
}
