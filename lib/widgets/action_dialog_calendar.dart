import 'package:flutter/material.dart';

class ActionDialog extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final DateTime dateFrom;
  final DateTime dateTo; 

  ActionDialog({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.dateFrom,
    @required this.dateTo,

  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
     title: Text(title),
     content: Text(description),
     actions: <Widget>[
       FlatButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
     ],
    );
  }
}

