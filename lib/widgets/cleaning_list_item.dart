import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './custom_icons_icons.dart';
import '../screens/cleaning/cleaning_detail_screen.dart';

class CleaningListItem extends StatelessWidget {
  final String id;
  final String apartment;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String route;

  CleaningListItem(
      {@required this.id,
      @required this.apartment,
      @required this.dateFrom,
      @required this.dateTo,
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
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CleaningDetailScreen(id: id),
            ),
          );
        },
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo[200],
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Icon(
                CustomIcons.trash,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Text(
          apartment,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(CustomIcons.clipboard),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      //apartment,
                      "Þrif á sameign",
                      style: TextStyle(fontSize: 15),
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
                  Expanded(
                    child: Text(
                      '${DateFormat.yMMMd().format(dateFrom)} - ${DateFormat.yMMMd().format(dateTo)}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // trailing: IconButton(
        //   icon: Icon(Icons.check),
        //   color: Colors.green,
        //   onPressed: () => {},
        // ),
      ),
    );
  }
}
