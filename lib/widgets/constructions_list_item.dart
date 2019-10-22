import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './custom_icons_icons.dart';

class ConstructionsListItem extends StatelessWidget {
  final String title;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String route;

  ConstructionsListItem(this.title, this.dateFrom, this.dateTo, this.route);

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
        leading: CircleAvatar(
          backgroundColor: Colors.grey[400],
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Icon(
                CustomIcons.tools,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Icon(Icons.date_range),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  '${DateFormat.yMMMd().format(dateFrom)} - ${DateFormat.yMMMd().format(dateTo)}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.comment),
          color: Colors.grey,
          onPressed: () => {},
        ),
      ),
    );
  }
}
