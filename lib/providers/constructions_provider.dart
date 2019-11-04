import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/construction.dart';

enum ConstructionStatus { current, ahead, old }

class ConstructionsProvider with ChangeNotifier {
  List<Construction> _dummyData = [
    Construction(
      id: "firebasekey1",
      title: "Viðgerð á þaki",
      dateFrom: DateTime.now().subtract(Duration(days: 10)),
      dateTo: DateTime.now().subtract(Duration(days: 7)),
      description: "",
    ),
    Construction(
      id: "firebasekey2",
      title: "Málað stigagang",
      dateFrom: DateTime.now().add(Duration(days: 5)),
      dateTo: DateTime.now().add(Duration(days: 7)),
      description: "",
    ),
    Construction(
      id: "firebasekey3",
      title: "Skipt um glugga",
      dateFrom: DateTime.now().add(Duration(days: 1)),
      dateTo: DateTime.now().add(Duration(days: 9)),
      description: "",
    ),
    Construction(
      id: "firebasekey4",
      title: "Sett upp grindverk",
      dateFrom: DateTime.now(),
      dateTo: DateTime.now().add(Duration(days: 12)),
      description: "",
    ),
    Construction(
      id: "firebasekey5",
      title: "Lagað dyrabjölluna",
      dateFrom: DateTime.now(),
      dateTo: DateTime.now().add(Duration(days: 16)),
      description: "",
    ),
    Construction(
      id: "firebasekey6",
      title: "Málað húsið",
      dateFrom: DateTime.now(),
      dateTo: DateTime.now().add(Duration(days: 20)),
      description: "",
    ),
  ];

  bool _constructionStatusFilter(
      int filterIndex, DateTime dateFrom, DateTime dateTo) {
    ConstructionStatus status = ConstructionStatus.values[filterIndex];
    DateTime exactDate = DateTime.now();
    DateTime startOfCurrentDate =
        DateTime(exactDate.year, exactDate.month, exactDate.day, 0, 0, 0, 0);
    DateTime endOfCurrentDate = DateTime(
        exactDate.year, exactDate.month, exactDate.day, 23, 59, 59, 999);
    switch (status) {
      case ConstructionStatus.current:
        return dateFrom.isBefore(endOfCurrentDate) &&
            (dateTo.compareTo(startOfCurrentDate) == 0 ||
                dateTo.isAfter(startOfCurrentDate));
      case ConstructionStatus.ahead:
        return dateFrom.isAfter(endOfCurrentDate);
      case ConstructionStatus.old:
        return dateTo.isBefore(startOfCurrentDate);
      default:
        return true;
    }
  }

  List<Construction> get items {
    return [..._dummyData];
  }

  /*List<Construction> getAllItemsForCalendar() {
    return [..._dummyData];
  }*/

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

  void addConstruction(Construction construction) {
    final newConstruction = Construction(
      title: construction.title,
      dateFrom: construction.dateFrom,
      dateTo: construction.dateTo,
      description: construction.description,
      id: DateTime.now().toString(),
    );
    _dummyData.add(newConstruction);
    notifyListeners();

    //Add to Firebase
    DocumentReference constructionRef = Firestore.instance
        .collection("ResidentAssociation")
        .document("09fnlNxhgYk70dMpaRJB");
    constructionRef.collection("ConstructionItems").add({
      'dateFrom:': construction.dateFrom,
      'dateTo:': construction.dateTo,
      'title:': construction.title,
      'description:': construction.description
    });
  }

  void deleteConstruction(String id) {
    _dummyData.removeWhere((construction) => construction.id == id);
    notifyListeners();
  }
}
