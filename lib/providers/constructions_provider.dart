import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/construction.dart';

enum ConstructionStatus { current, ahead, old }

class ConstructionsProvider with ChangeNotifier {
  List<Construction> _constructions = [];

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection('ResidentAssociation');

  // function which fetches the constructions of a resident association
  // and stores them in the _constructions list.
  Future<void> fetchConstructions(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection('ConstructionItems')
          .getDocuments();
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
          authorId: construction.data['authorId'],
        ));
      });
      loadedConstructions.sort(
        (a, b) => a.dateFrom.compareTo(b.dateFrom) == 0
            ? a.dateTo.compareTo(b.dateTo)
            : a.dateFrom.compareTo(b.dateFrom),
      );
      _constructions = loadedConstructions;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp framkvæmdum!'),
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

  // function which adds a construction to a resident association.
  Future<void> addConstruction(
      String residentAssociationId, Construction construction) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection('ConstructionItems')
          .add({
        'title': construction.title,
        'dateFrom': construction.dateFrom.millisecondsSinceEpoch,
        'dateTo': construction.dateTo.millisecondsSinceEpoch,
        'description': construction.description,
        'authorId': construction.authorId,
      });
      final newConstruction = Construction(
        title: construction.title,
        dateFrom: construction.dateFrom,
        dateTo: construction.dateTo,
        description: construction.description,
        authorId: construction.authorId,
        id: response.documentID,
      );
      _constructions.add(newConstruction);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which deletes a construction from a resident association.
  Future<void> deleteConstruction(
      String residentAssociationId, String constructionId) async {
    final deleteIndex = _constructions
        .indexWhere((construction) => construction.id == constructionId);
    var deletedConstruction = _constructions[deleteIndex];
    _constructions.removeAt(deleteIndex);
    notifyListeners();
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection('ConstructionItems')
          .document(constructionId)
          .delete();
      deletedConstruction = null;
    } catch (error) {
      _constructions.insert(deleteIndex, deletedConstruction);
      notifyListeners();
    }
  }

  // function which returns a construction which has the id taken in as
  // parameter, if found.
  Construction findById(String id) {
    return _constructions.firstWhere((construction) => construction.id == id);
  }

  // function which updates a construction in a resident association.
  Future<void> updateConstruction(
      String residentAssociationId, Construction editedConstruction) async {
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection('ConstructionItems')
          .document(editedConstruction.id)
          .updateData({
        'title': editedConstruction.title,
        'dateFrom': editedConstruction.dateFrom.millisecondsSinceEpoch,
        'dateTo': editedConstruction.dateTo.millisecondsSinceEpoch,
        'description': editedConstruction.description,
        'authorId': editedConstruction.authorId,
      });
      final constructionIndex = _constructions.indexWhere(
          (construction) => construction.id == editedConstruction.id);
      if (constructionIndex >= 0) {
        _constructions[constructionIndex] = editedConstruction;
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // functions which filters constructions whether they are ahead, old or currently taking place.
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

  // function which return a list of construction which contain the search query and
  // match a given status filter (ahead, current or old).
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
    } else {
      constructions.forEach((item) {
        if (_events.containsKey(item.dateFrom)) {
          _events[item.dateFrom].add(
            ["Framkvæmd:    ", item.title, item.description, "Framkvæmd"],
          );
        } else {
          _events[item.dateFrom] = [
            ["Framkvæmd:    ", item.title, item.description, "Framkvæmd"],
          ];
        }
        return _events;
      });
      return _events;
    }
  }
}
