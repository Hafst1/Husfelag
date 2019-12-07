import 'package:flutter/material.dart';

import '../shared/constants.dart' as Constants;

class DetailDateItem extends StatelessWidget {
  final String text;
  final DateTime date;

  DetailDateItem({
    @required this.text,
    @required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 75,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.date_range,
                size: 30,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: Text(
              '${Constants.weekdays[date.weekday - 1]}, ${date.day}. ${Constants.months[date.month - 1].toLowerCase()} ${date.year}',
              style: TextStyle(fontSize: 17),
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
