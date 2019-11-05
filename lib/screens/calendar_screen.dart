import 'package:flutter/material.dart';
//import 'package:husfelagid/models/construction.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

//import '../widgets/tab_filter_button.dart';
import '../providers/constructions_provider.dart';

class CalendarScreen extends StatefulWidget {
  final String title;
  final DateTime dateFrom;

  const CalendarScreen({Key key, this.title, this.dateFrom}):
  super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin {
  //List<Construction> _constructions;
  Map<DateTime, List> _events;
  List _selectedEvents;
  CalendarController _calendarController;
  AnimationController _animationController;
 
  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      //Dagar í fortíðinni 
      _selectedDay.subtract(Duration(days: 10)): ['Þrif', 'framkvæmdir', 'fundur'],
      _selectedDay.subtract(Duration(days: 4)): ['fundur', 'framkvæmdir'],
      _selectedDay.subtract(Duration(days: 2)): ['fundur', 'þrif'],
      _selectedDay: ['fundur', 'þrif'],
      //Dagar í framtíðinni
      _selectedDay.add(Duration(days: 1)): ['Fundur', 'framkvæmdir', 'Stjórnarfundur', 'þrif'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Fundur', 'Framkvæmdir á þaki', 'Þrif']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Þrif', 'Fundur', 'Framkvæmdir á glugga'],
      _selectedDay.add(Duration(days: 11)): ['þrifa á sameign', 'Framkvæmdir'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  /*_selectOnDayConstructions(List<Construction> constructionList) {
    setState(() {

      _events = constructionList as Map<DateTime, List>;
      constructionList = _constructions;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final constructionData = Provider.of<ConstructionsProvider>(context);
    final _constructions = constructionData.getAllItemsForCalendar();
   // _constructions = constructionData.getAllItemsForCalendar();   //sækja allar framkvæmdir/ og setja í events
   // _selectOnDayConstructions(_constructions);  
    return Scaffold(
      appBar: AppBar(
        title: Text("Dagatal"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,                              //hérna kallað í eventana
      startingDayOfWeek: StartingDayOfWeek.monday, //Byrjar á mánudegi
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],    //calendarstyle
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],        //punktarnir
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(                 //til að stilla viku/2vikur/mánuð
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,                //kallar í fallið _onDaySelected
      onVisibleDaysChanged: _onVisibleDaysChanged,   //kallar í fallið _onVisibleDaysChanged
    );
  }

  Widget _buildEventList() {              //Býr til event-listann
    return ListView(
      children: _selectedEvents
          .map((event) => Container(        //mappar eventana
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}