import 'package:flutter/material.dart';

import '../models/meeting.dart';

enum MeetingStatus { ahead, old }

class MeetingsProvider with ChangeNotifier {
  List<Meeting> _dummyData = [
    Meeting(
      title: "Árlegur húsfundur",
      date: DateTime.now().add(Duration(days: 4)),
      duration: Duration(hours: 2),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      title: "Neyðarfundur",
      date: DateTime.now(),
      duration: Duration(hours: 1),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      title: "Fundað um húsið",
      date: DateTime.now().add(Duration(days: 4)),
      duration: Duration(hours: 2),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      title: "Stórfundur",
      date: DateTime.now(),
      duration: Duration(hours: 1),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      title: "Fundur",
      date: DateTime.now().add(Duration(days: 4)),
      duration: Duration(hours: 2),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      title: "Örfundur",
      date: DateTime.now(),
      duration: Duration(hours: 1),
      location: "Egilshöll",
      description: "",
    ),
  ];

  List<Meeting> get items {
    return [..._dummyData];
  }

  bool _meetingStatusFilter(
      int filterIndex, DateTime date) {
    MeetingStatus status = MeetingStatus.values[filterIndex];
    DateTime currentDate = DateTime.now();
    switch (status) {
      case MeetingStatus.ahead:
        return date.isAfter(currentDate);
      case MeetingStatus.old:
        return date.isBefore(currentDate);
      default:
        return true;
    }
  }

  List<Meeting> filteredItems(String query, int filterIndex) {
    List<Meeting> constructions = [..._dummyData];
    String searchQuery = query.toLowerCase();
    List<Meeting> displayList = [];
    if (query.isNotEmpty) {
      constructions.forEach((item) {
        if (item.title.toLowerCase().contains(searchQuery) &&
            _meetingStatusFilter(
              filterIndex,
              item.date,
            )) {
          displayList.add(item);
        }
      });
    } else {
      constructions.forEach((item) {
        if (_meetingStatusFilter(
              filterIndex,
              item.date,
            )) {
          displayList.add(item);
        }
      });
    }
    return displayList;
  }
}