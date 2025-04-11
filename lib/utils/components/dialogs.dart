import 'package:flutter/material.dart';

Future<void> showDeleteDialog(BuildContext context, String title, Widget content, List<Widget> actions) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge,),
        content: content,
        actions: actions,
      );
    },
  );
}