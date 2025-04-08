import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/assets.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String markdownContent = "";

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    String content = await rootBundle.loadString(Assets.filesAbout);
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
          p: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack), fontSize: 14, fontFamily: 'Outfit'),
          h1: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack), fontSize: 36, fontFamily: 'Outfit'),
          h2: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack), fontSize: 28, fontFamily: 'Outfit'),
          h3: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack), fontSize: 34, fontFamily: 'Outfit'),
          h1Padding: EdgeInsets.zero,
          pPadding: EdgeInsets.zero,
          h2Padding: EdgeInsets.zero,
          listBullet: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack), fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: WrapAlignment.spaceAround,
        )),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
