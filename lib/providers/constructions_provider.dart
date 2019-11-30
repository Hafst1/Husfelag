import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/construction.dart';

enum ConstructionStatus { current, ahead, old }

class ConstructionsProvider with ChangeNotifier {
  List<Construction> _constructions = [];

  Future<void> fetchConstructions(BuildContext context) async {
    DocumentReference constructionRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    try {
      final response =
          await constructionRef.collection('ConstructionItems').getDocuments();
      final List<Construction> loadedConstructions = [];
      response.documents.forEach((construction) {
        loadedConstructions.add(Construction(
          id: construction.documentID,
          title: construction.data['title'],
          dateFrom: DateTime.fromMillisecondsSinceEpoch(
              construction.data['dateFrom']),
          dateTo:
              DateTime.fromMillisecondsSinceEpoch(construction.data['dateTo']),
          description: construction.data['description'],
        ));
      });
      _constructions = loadedConstructions;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp fundum!'),
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

  Future<void> addConstruction(Construction construction) async {
    DocumentReference constructionRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    try {
      final response =
          await constructionRef.collection('ConstructionItems').add({
        'title': construction.title,
        'dateFrom': construction.dateFrom.millisecondsSinceEpoch,
        'dateTo': construction.dateTo.millisecondsSinceEpoch,
        'description': construction.description
      });
      final newConstruction = Construction(
        title: construction.title,
        dateFrom: construction.dateFrom,
        dateTo: construction.dateTo,
        description: construction.description,
        id: response.documentID,
      );
      _constructions.add(newConstruction);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteConstruction(String id) async {
    DocumentReference constructionRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    final deleteIndex =
        _constructions.indexWhere((construction) => construction.id == id);
    var deletedConstruction = _constructions[deleteIndex];
    _constructions.removeAt(deleteIndex);
    notifyListeners();
    try {
      await constructionRef
          .collection('ConstructionItems')
          .document(id)
          .delete();
      deletedConstruction = null;
    } catch (error) {
      _constructions.insert(deleteIndex, deletedConstruction);
      notifyListeners();
    }
  }

  Construction findById(String id) {
    return _constructions.firstWhere((construction) => construction.id == id);
  }

  Future<void> updateConstruction(
      String id, Construction editedConstruction) async {
    DocumentReference constructionRef = Firestore.instance
        .collection("ResidentAssociation")
        .document("09fnlNxhgYk70dMpaRJB");
    try {
      await constructionRef
          .collection('ConstructionItems')
          .document(id)
          .updateData({
        'title': editedConstruction.title,
        'dateFrom': editedConstruction.dateFrom.millisecondsSinceEpoch,
        'dateTo': editedConstruction.dateTo.millisecondsSinceEpoch,
        'description': editedConstruction.description,
      });
      final constructionIndex =
          _constructions.indexWhere((construction) => construction.id == id);
      if (constructionIndex >= 0) {
        _constructions[constructionIndex] = editedConstruction;
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

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

  List<Construction> filteredItems(String query, int filterIndex) {
    List<Construction> constructions = [..._constructions];
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

  Map<DateTime, List> filterForCalendar() {
    List<Construction> constructions = [..._constructions];
    Map<DateTime, List> _events = Map();
    if (constructions == []) {
      return null;
    }else {
      constructions.forEach((item) {
        if(_events.containsKey(item.dateFrom)) { 
          _events[item.dateFrom].add(["Framkvæmd" , item.title,  item.description,  
           "Framkvæmd"],); 
        }else {
             _events[item.dateFrom] = [["Framkvæmd" , item.title,  item.description,
               "Framkvæmd"],];
          }
        return _events; 
      });
    return _events;
    }
  }
}

