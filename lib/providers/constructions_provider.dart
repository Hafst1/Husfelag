import 'package:flutter/material.dart';

import '../models/construction.dart';

enum ConstructionStatus { current, ahead, old }

class ConstructionsProvider with ChangeNotifier {
  List<Construction> _dummyData = [
    Construction(
      title: "Viðgerð á þaki",
      dateFrom: DateTime.now().subtract(Duration(days: 10)),
      dateTo: DateTime.now().subtract(Duration(days: 7)),
      description: "",
    ),
    Construction(
      title: "Málað stigagang",
      dateFrom: DateTime.now().add(Duration(days: 5)),
      dateTo: DateTime.now().add(Duration(days: 7)),
      description: "",
    ),
    Construction(
      title: "Skipt um glugga",
      dateFrom: DateTime.now().add(Duration(days: 1)),
      dateTo: DateTime.now().add(Duration(days: 9)),
      description: "",
    ),
    Construction(
      title: "Sett upp grindverk",
      dateFrom: DateTime.now(),
      dateTo: DateTime.now().add(Duration(days: 12)),
      description: "",
    ),
    Construction(
      title: "Lagað dyrabjölluna",
      dateFrom: DateTime.now(),
      dateTo: DateTime.now().add(Duration(days: 16)),
      description: "",
    ),
    Construction(
      title: "Málað húsið",
      dateFrom: DateTime.now(),
      dateTo: DateTime.now().add(Duration(days: 20)),
      description: "",
    ),
  ];

  bool _constructionStatusFilter(
      int filterIndex, DateTime dateFrom, DateTime dateTo) {
    ConstructionStatus status = ConstructionStatus.values[filterIndex];
    DateTime currentDate = DateTime.now();
    switch (status) {
      case ConstructionStatus.current:
        return dateFrom.isBefore(currentDate) && dateTo.isAfter(currentDate);
      case ConstructionStatus.ahead:
        return dateFrom.isAfter(currentDate);
      case ConstructionStatus.old:
        return dateTo.isBefore(currentDate);
      default:
        return true;
    }
  }

  List<Construction> get items {
    return [..._dummyData];
  }

  List<Construction> filteredItems(String query, int filterIndex) {
    List<Construction> constructions = [..._dummyData];
    String searchQuery = query.toLowerCase();
    List<Construction> displayList = [];
    if (query.isNotEmpty) {
      constructions.forEach((item) {
        if (item.title.toLowerCase().contains(searchQuery) &&
            _constructionStatusFilter(
              filterIndex,
              item.dateFrom,
              item.dateTo,
            )) {
          displayList.add(item);
        }
      });
    } else {
      constructions.forEach((item) {
        if (_constructionStatusFilter(
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
