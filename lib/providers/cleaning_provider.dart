import 'package:flutter/material.dart';

import '../models/cleaning.dart';

enum CleaningStatus { current, ahead, old }

class CleaningProvider with ChangeNotifier {
  List<Cleaning> _dummyData = [
    Cleaning(
      apartment: "Íbúð 104",
      dateFrom: DateTime.now().subtract(Duration(days: 10)),
      dateTo: DateTime.now().subtract(Duration(days: 7)),

    ),
    Cleaning(
      apartment: "Íbúð 103",
      dateFrom: DateTime.now().add(Duration(days: 5)),
      dateTo: DateTime.now().add(Duration(days: 7)),

    ),
    Cleaning(
      apartment: "Íbúð 102",
      dateFrom: DateTime.now().add(Duration(days: 1)),
      dateTo: DateTime.now().add(Duration(days: 9)),

    ),
    Cleaning(
      apartment: "Íbúð 101",
      dateFrom: DateTime.now(),
      dateTo: DateTime.now().add(Duration(days: 12)),

    ),
    Cleaning(
      apartment: "Íbúð 107",
      dateFrom: DateTime.now().subtract(Duration(days: 20)),
      dateTo: DateTime.now().subtract(Duration(days: 16)),

    ),
    Cleaning(
      apartment: "Íbúð 109",
      dateFrom: DateTime.now().subtract(Duration(days: 28)),
      dateTo: DateTime.now().subtract(Duration(days: 25)),    ),
  ];

  List<Cleaning> get items {
    return [..._dummyData];
  }

  bool _cleaningStatusFilter(
      int filterIndex, DateTime dateFrom, DateTime dateTo) {
    CleaningStatus status = CleaningStatus.values[filterIndex];
    DateTime currentDate = DateTime.now();
    switch (status) {
      case CleaningStatus.current:
        return dateFrom.isBefore(currentDate) && dateTo.isAfter(currentDate);
      case CleaningStatus.ahead:
        return dateFrom.isAfter(currentDate);
      case CleaningStatus.old:
        return dateTo.isBefore(currentDate);
      default:
        return true;
    }
  }

  List<Cleaning> filteredItems(String query, int filterIndex) {
    List<Cleaning> constructions = [..._dummyData];
    String searchQuery = query.toLowerCase();
    List<Cleaning> displayList = [];
    if (query.isNotEmpty) {
      constructions.forEach((item) {
        if (item.apartment.toLowerCase().contains(searchQuery) &&
            _cleaningStatusFilter(
              filterIndex,
              item.dateFrom,
              item.dateTo,
            )) {
          displayList.add(item);
        }
      });
    } else {
      constructions.forEach((item) {
        if (_cleaningStatusFilter(
              filterIndex,
              item.dateFrom,
              item.dateTo,
            )) {
          displayList.add(item);
        }
      });
    }
    return displayList;
  }
}