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
            TableCalendar(
              calendarStyle: CalendarStyle(
                todayColor: Colors.purple,
                todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white
                ),
                selectedColor: Theme.of(context).primaryColor,
                selectedStyle: TextStyle(
                  color: Colors.black
                )
              ),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarController: _controller,)
          ],
        ),
      ),
    );
  }
}