import 'package:flutter/material.dart';

class CleaningTaskItem extends StatelessWidget {
  final String title;
  final String description;
  final String route; 

  CleaningTaskItem(
    {@required this.title,
    @required this.description,
    @required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
    margin: EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 5,
    ),
    elevation: 5,
    child: ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
    )
    );
  }
}

