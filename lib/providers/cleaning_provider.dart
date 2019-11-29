import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:husfelagid/models/cleaning_task.dart';
import '../models/apartment.dart';
import '../models/cleaning.dart';

enum CleaningStatus { current, ahead, old }

class CleaningProvider with ChangeNotifier {
  List<Cleaning> _cleaningItems = [];
  List<CleaningTask> _cleaningTask = [];
 
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

  List<Apartment> get apartmentItems {
    return [..._dummyData2];
  }
  
  List<CleaningTask> getAllTasks() {
    return [..._cleaningTask];
  }

  Future<void> fetchCleaningItems(BuildContext context) async {
    DocumentReference cleaningRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    try {
      final response =
          await cleaningRef.collection('CleaningItems').getDocuments();
      final List<Cleaning> loadedCleaningItems = [];
      response.documents.forEach((cleaningItem) {
        loadedCleaningItems.add(Cleaning(
          id: cleaningItem.documentID,
          apartment: cleaningItem.data['apartment'],
          dateFrom: DateTime.fromMillisecondsSinceEpoch(
              cleaningItem.data['dateFrom']),
          dateTo:
              DateTime.fromMillisecondsSinceEpoch(cleaningItem.data['dateTo']),
        ));
      });
      _cleaningItems = loadedCleaningItems;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp þrifum!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Halda áfram'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  Future<void> addCleaningItem(Cleaning cleaningItem) async {
    DocumentReference cleaningRef = Firestore.instance
        .collection("ResidentAssociation")
        .document("09fnlNxhgYk70dMpaRJB");
    try {
      final response = await cleaningRef.collection("CleaningItems").add({
        'apartment': cleaningItem.apartment,
        'dateFrom': cleaningItem.dateFrom.millisecondsSinceEpoch,
        'dateTo': cleaningItem.dateTo.millisecondsSinceEpoch,
      });
      final newCleaningItem = Cleaning(
        apartment: cleaningItem.apartment,
        dateFrom: cleaningItem.dateFrom,
        dateTo: cleaningItem.dateTo,
        id: response.documentID,
      );
      _cleaningItems.add(newCleaningItem);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteCleaningItem(String id) async {
    DocumentReference cleaningRef = Firestore.instance
        .collection("ResidentAssociation")
        .document("09fnlNxhgYk70dMpaRJB");
    final deleteIndex =
        _cleaningItems.indexWhere((cleaningItem) => cleaningItem.id == id);
    var deletedCleaningItem = _cleaningItems[deleteIndex];
    _cleaningItems.removeAt(deleteIndex);
    notifyListeners();
    try {
      await cleaningRef.collection('CleaningItems').document(id).delete();
      deletedCleaningItem = null;
    } catch (error) {
      _cleaningItems.insert(deleteIndex, deletedCleaningItem);
      notifyListeners();
    }
  }

  Cleaning findById(String id) {
    return _cleaningItems.firstWhere((cleaning) => cleaning.id == id);
  }

  Future<void> updateCleaningItem(String id, Cleaning editedCleaning) async {
    DocumentReference cleaningRef = Firestore.instance
        .collection("ResidentAssociation")
        .document("09fnlNxhgYk70dMpaRJB");
    try {
      await cleaningRef.collection('CleaningItems').document(id).updateData({
        'apartment': editedCleaning.apartment,
        'dateFrom': editedCleaning.dateFrom.millisecondsSinceEpoch,
        'dateTo': editedCleaning.dateTo.millisecondsSinceEpoch,
      });
      final cleaningIndex =
          _cleaningItems.indexWhere((cleaning) => cleaning.id == id);
      if (cleaningIndex >= 0) {
        _cleaningItems[cleaningIndex] = editedCleaning;
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
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
    List<Cleaning> constructions = [..._cleaningItems];
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

  Future<void> fetchCleaningTasks(BuildContext context) async {
    DocumentReference cleaningTaskRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    try {
      final response =
          await cleaningTaskRef.collection('CleaningTasks').getDocuments();
      final List<CleaningTask> loadedCleaningTask = [];
      response.documents.forEach((cleaningTask) {
        loadedCleaningTask.add(CleaningTask(
          id: cleaningTask.documentID,
          title: cleaningTask.data['title'],
          description: cleaningTask.data['description'],
          taskDone: true,
        ));
      });
      _cleaningTask = loadedCleaningTask;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp verkefnalista!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Halda áfram'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }
  void updateCleaningTask(String id, CleaningTask editedCleaningTask) {
    final cleaningTaskIndex = _cleaningTask.indexWhere((cleaningTask) => cleaningTask.id == id);
    _cleaningTask[cleaningTaskIndex] = editedCleaningTask;
    notifyListeners();
  }

   CleaningTask findCleaningTaskById(String id) {
    return _cleaningTask.firstWhere((cleaningTask) => cleaningTask.id == id);
  } 
}
