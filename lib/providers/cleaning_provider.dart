import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/apartment.dart';
import '../models/cleaning.dart';

enum CleaningStatus { current, ahead, old }

class CleaningProvider with ChangeNotifier {
  List<Cleaning> _dummyData = [
    Cleaning(
      id: "Firebasekey1",
      apartment: "Íbúð 104",
      dateFrom: DateTime.now().subtract(Duration(days: 10)),
      dateTo: DateTime.now().subtract(Duration(days: 7)),
    ),
    Cleaning(
      id: "Firebasekey2",
      apartment: "Íbúð 103",
      dateFrom: DateTime.now().add(Duration(days: 5)),
      dateTo: DateTime.now().add(Duration(days: 7)),
    ),
    Cleaning(
      id: "Firebasekey3",
      apartment: "Íbúð 102",
      dateFrom: DateTime.now().add(Duration(days: 1)),
      dateTo: DateTime.now().add(Duration(days: 9)),
    ),
    Cleaning(
      id: "Firebasekey4",
      apartment: "Íbúð 101",
      dateFrom: DateTime.now(),
      dateTo: DateTime.now().add(Duration(days: 12)),
    ),
    Cleaning(
      id: "Firebasekey5",
      apartment: "Íbúð 107",
      dateFrom: DateTime.now().subtract(Duration(days: 20)),
      dateTo: DateTime.now().subtract(Duration(days: 16)),
    ),
    Cleaning(
      id: "Firebasekey6",
      apartment: "Íbúð 109",
      dateFrom: DateTime.now().subtract(Duration(days: 28)),
      dateTo: DateTime.now().subtract(Duration(days: 25)),
    ),
  ];

  List<Apartment> _dummyData2 = [
    Apartment(
      apartmentNumber: "Íbúð 101",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 102",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 103",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 104",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 201",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 202",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 203",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 204",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 301",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 302",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 303",
      residents: ["Siggi", "Baddi"],
    ),
    Apartment(
      apartmentNumber: "Íbúð 304",
      residents: ["Siggi", "Baddi"],
    ),
  ];

  List<Cleaning> get items {
    return [..._dummyData];
  }

  List<Apartment> get apartmentItems {
    return [..._dummyData2];
  }

  bool _cleaningStatusFilter(
      int filterIndex, DateTime dateFrom, DateTime dateTo) {
    CleaningStatus status = CleaningStatus.values[filterIndex];
    DateTime exactDate = DateTime.now();
    DateTime startOfCurrentDate =
        DateTime(exactDate.year, exactDate.month, exactDate.day, 0, 0, 0, 0);
    DateTime endOfCurrentDate = DateTime(
        exactDate.year, exactDate.month, exactDate.day, 23, 59, 59, 999);
    switch (status) {
      case CleaningStatus.current:
        return dateFrom.isBefore(endOfCurrentDate) &&
            (dateTo.compareTo(startOfCurrentDate) == 0 ||
                dateTo.isAfter(startOfCurrentDate));
      case CleaningStatus.ahead:
        return dateFrom.isAfter(endOfCurrentDate);
      case CleaningStatus.old:
        return dateTo.isBefore(startOfCurrentDate);
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

  void addCleaningItem(Cleaning cleaningItem) {
    final newCleaningItem = Cleaning(
      apartment: cleaningItem.apartment,
      dateFrom: cleaningItem.dateFrom,
      dateTo: cleaningItem.dateTo,
      id: DateTime.now().toString(),
    );
    _dummyData.add(newCleaningItem);
    notifyListeners();

     //Add to Firebase
    DocumentReference cleaningRef = Firestore.instance
        .collection("ResidentAssociation")
        .document("09fnlNxhgYk70dMpaRJB");
    cleaningRef.collection("CleaningItems").add({
      'apartment:': cleaningItem.apartment,
      'dateFrom:': cleaningItem.dateFrom,
      'dateTo:': cleaningItem.dateTo
    });
  }

  void deleteCleaningItem(String id) {
    _dummyData.removeWhere((cleaningItem) => cleaningItem.id == id);
    notifyListeners();
  }
}
