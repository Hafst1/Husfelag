import 'package:flutter/material.dart';
import 'package:husfelagid/widgets/tab_filter_button.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:provider/provider.dart';

import '../widgets/tab_filter_button.dart';
//import '../providers/constructions_provider.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _controller;

  int _selectedFilterIndex = 0; 

  _selectFilter(int index) {
    setState(() {
      _selectedFilterIndex = index; 
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    final _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
   Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Dagatal"),
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
   // final constructionData = Provider.of<ConstructionsProvider>(context);
    //final constructions = constructionData.getAllItemsForCalendar();
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TabFilterButton(
                    buttonFilterId: 0,
                    buttonText: "Fundir",
                    buttonFunc: _selectFilter,
                    buttonHeight: heightOfBody * 0.1,
                    filterIndex: _selectedFilterIndex),
                ),
                Expanded(
                  child: TabFilterButton(
                    buttonFilterId: 1,
                    buttonText: "Þrif",
                    buttonFunc: _selectFilter,
                    buttonHeight: heightOfBody * 0.1,
                    filterIndex: _selectedFilterIndex),
                ),
                Expanded(
                  child: TabFilterButton(
                    buttonFilterId: 2,
                    buttonText: "Framkvæmdir",
                    buttonFunc: _selectFilter,
                    buttonHeight: heightOfBody * 0.1,
                    filterIndex: _selectedFilterIndex),
                )
              ],
            ),
            TableCalendar(
             // onDaySelected: ,
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
                ),
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