import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:table_calendar/table_calendar.dart'; /*Oddný bætti þessu vid*/

/*Oddný Bætti þessu vid */
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dagatal'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(calendarController: _controller,)
          ],
        ),
      ),
    );
  }
}