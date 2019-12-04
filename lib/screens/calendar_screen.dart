import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../providers/constructions_provider.dart';
import '../providers/current_user_provider.dart';
import '../providers/cleaning_provider.dart';
import '../providers/meetings_provider.dart';
import '../shared/loading_spinner.dart';
import '../models/construction.dart';
import '../models/meeting.dart';
import '../models/cleaning.dart';
import '../widgets/constructions_list_item.dart';
import '../widgets/meetings_list_item.dart';
import '../widgets/cleaning_list_item.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  CalendarController _calendarController;
  AnimationController _animationController;
  Map<DateTime, List> _events = {};
  List _selectedEvents = [];
  static var currentDate = DateTime.now();
  var _daySelected = DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day,
  );

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  // fetch constructions, meetings and cleaning items before widget is built.
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getResidentAssociationId();
      Provider.of<MeetingsProvider>(context, listen: false)
          .fetchMeetings(residentAssociationId, context)
          .then((_) {
        Provider.of<ConstructionsProvider>(context, listen: false)
            .fetchConstructions(residentAssociationId, context)
            .then((_) {
          Provider.of<CleaningProvider>(context, listen: false)
              .fetchCleaningItems(residentAssociationId, context)
              .then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // function which updates the day selected and the list of events to display
  // beneath the calendar.
  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _daySelected = DateTime(
        day.year,
        day.month,
        day.day,
      );
      _selectedEvents = events;
    });
  }

  // function which generates the calendar events list.
  void generateEventsList(
    List<Construction> constructions,
    List<Meeting> meetings,
    List<Cleaning> cleaningItems,
    bool isAdmin,
    String userId,
  ) {
    meetings.forEach((meeting) {
      final meetingKey = DateTime(
        meeting.date.year,
        meeting.date.month,
        meeting.date.day,
      );
      final meetingValue = MeetingsListItem(
        id: meeting.id,
        title: meeting.title,
        date: meeting.date,
        location: meeting.location,
        isAdmin: isAdmin,
        isAuthor: meeting.authorId == userId,
      );
      if (_events.containsKey(meetingKey)) {
        _events[meetingKey].add(meetingValue);
      } else {
        _events[meetingKey] = [meetingValue];
      }
    });

    constructions.forEach((construction) {
      final constructionkey = DateTime(
        construction.dateFrom.year,
        construction.dateFrom.month,
        construction.dateFrom.day,
      );
      final constructionValue = ConstructionsListItem(
        id: construction.id,
        title: construction.title,
        dateFrom: construction.dateFrom,
        dateTo: construction.dateTo,
        isAdmin: isAdmin,
        isAuthor: construction.authorId == userId,
      );
      if (_events.containsKey(constructionkey)) {
        _events[constructionkey].add(constructionValue);
      } else {
        _events[constructionkey] = [constructionValue];
      }
    });

    cleaningItems.forEach((cleaningItem) {
      final cleaningItemkey = DateTime(
        cleaningItem.dateFrom.year,
        cleaningItem.dateFrom.month,
        cleaningItem.dateFrom.day,
      );
      final cleaningItemValue = CleaningListItem(
        id: cleaningItem.id,
        apartment: cleaningItem.apartment,
        dateFrom: cleaningItem.dateFrom,
        dateTo: cleaningItem.dateTo,
        isAdmin: isAdmin,
        isAuthor: cleaningItem.authorId == userId,
      );
      if (_events.containsKey(cleaningItemkey)) {
        _events[cleaningItemkey].add(cleaningItemValue);
      } else {
        _events[cleaningItemkey] = [cleaningItemValue];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
    final meetings = Provider.of<MeetingsProvider>(context).getAllMeetings();
    final constructions =
        Provider.of<ConstructionsProvider>(context).getAllConstructions();
    final cleaningItems =
        Provider.of<CleaningProvider>(context).getAllCleaningItems();
    _events = {};
    generateEventsList(
      constructions,
      meetings,
      cleaningItems,
      currentUserData.isAdmin(),
      currentUserData.getId(),
    );
    if (_events.containsKey(_daySelected)) {
      _selectedEvents = _events[_daySelected];
    } else {
      _selectedEvents = [];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Dagatal"),
        centerTitle: true,
      ),
      body: _isLoading
          ? LoadingSpinner()
          : Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildTableCalendar(),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 8.0),
                  Expanded(child: _buildEventList()),
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
        selectedColor: Colors.pink[400],
        todayColor: Colors.pink[200],
        markersColor: Colors.grey[800],
        weekendStyle: TextStyle(color: Theme.of(context).accentColor),
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.pink[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Column(
      children: <Widget>[
        _selectedEvents.isNotEmpty
            ? Divider(
                thickness: 2,
              )
            : Container(),
        Expanded(
          child: ListView(
            children: _selectedEvents.map<Widget>((event) => event).toList(),
          ),
        ),
      ],
    );
  }
}