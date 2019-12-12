import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  NotificationItem({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.date
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
      onTap: () {
        Counter.listItemCounter = 0;  ///athuga, þetta virkar ekki
      },
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(description, style: TextStyle(fontSize: 15),),
          Text('Tilkynning sett inn: ' + date.day.toString() + '.' + 
                date.month.toString() + '.' + date.year.toString() + ' ' + date.hour.toString() + 
                ':' +date.minute.toString().padLeft(2,'0')
          ),
        ],
      )
    );
  }
}