import 'package:flutter/material.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 5,
      child: ListTile(
        isThreeLine: true,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(arguments: id),
            ),
          );
        },
        title: Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(description, style: TextStyle(fontSize: 15),),
            Text('Tilkynning sett inn: ' + date.day.toString() + '.' + 
                  date.month.toString() + '.' + date.year.toString() + ' ' + date.hour.toString() + ':' +date.minute.toString()),
          ],
        )
      ),
    );
  }
}