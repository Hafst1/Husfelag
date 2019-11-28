import 'package:flutter/material.dart';
import 'package:husfelagid/providers/meetings_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import 'package:husfelagid/widgets/action_dialog_calendar.dart';
import '../providers/constructions_provider.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin {
  Map<DateTime, List> _events;  //skipta um nafn við constructionEvents? 
  Map<DateTime, List> _meetingEvents;
  Map<DateTime, List> _constructionEvents;
  List _selectedEvents;
  CalendarController _calendarController;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    /*final constructionEvents = Provider.of<ConstructionsProvider>(context);
    _events = constructionEvents.filterForCalendar();
    _selectedEvents = _events[DateTime.now()] ?? [];*/
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    final constructionEvents = Provider.of<ConstructionsProvider>(context);
    _events = constructionEvents.filterForCalendar();
    _selectedEvents = _events[DateTime.now()] ?? [];
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nánar um eventinn"),
          content: Text("staðsetning, tími"),
          actions: <Widget> [
            FlatButton(
              child: Text("Loka"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]
        );
      }
    );
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;

    });
  }

  /*Map<DateTime, List> mergeMeetingsAndConstructions() {
    final meetingEvents = Provider.of<MeetingsProvider>(context);
    _meetingEvents = meetingEvents.filterForCalendar();

    return _meetingEvents; 
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Dagatal"),
      ),
      body: Container (
        color: Colors.white60,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList()
            ),
        ],
      ),
      ),
    );
  }
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,                              
      startingDayOfWeek: StartingDayOfWeek.monday, 
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],    
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],        
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(              
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,                   
    );
  }

  Widget _buildEventList() {              
    return ListView(
      children: _selectedEvents
          .map((event) => Container(    
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Container(
                  color: Colors.blueGrey[100],
                  child: ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text(
                      event.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => _showActionDialog(context)/*print('$event tapped!')*/,
                  ),
                ),
              ))
          .toList(),
    );
  }
}