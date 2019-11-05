import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './custom_icons_icons.dart';

class DocumentListItem extends StatelessWidget {
  final String title;
  final String route;

  DocumentListItem(
      {@required this.title,
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
      ),
    );
  }
}
