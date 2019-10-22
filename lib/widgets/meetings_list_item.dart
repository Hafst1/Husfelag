import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './custom_icons_icons.dart';

class MeetingsListItem extends StatelessWidget {
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String route;

  MeetingsListItem(
    this.title,
    this.date,
    this.time,
    this.location,
    this.route,
  );

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
          backgroundColor: Colors.brown[200],
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Icon(
                CustomIcons.group,
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
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.date_range),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${DateFormat.yMMMd().format(date)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.access_time),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      time,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.check),
          color: Colors.green,
          onPressed: () => {},
        ),
      ),
    );
  }
}
