import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cleaning_task.dart';
import '../models/cleaning.dart';

enum CleaningStatus { current, ahead, old }

class CleaningProvider with ChangeNotifier {
  List<Cleaning> _cleaningItems = [];
  List<CleaningTask> _cleaningTasks = [];

  // collection reference to resident associations.
  CollectionReference _associationsRef =
      Firestore.instance.collection('ResidentAssociation');

  // function which fetches cleaning items of a resident association
  // and stores them in the _cleaningItems list.
  Future<void> fetchCleaningItems(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationsRef
          .document(residentAssociationId)
          .collection('CleaningItems')
          .getDocuments();
      final List<Cleaning> loadedCleaningItems = [];
      response.documents.forEach((cleaningItem) {
        loadedCleaningItems.add(Cleaning(
          id: cleaningItem.documentID,
          apartment: cleaningItem.data['apartment'],
          dateFrom: DateTime.fromMillisecondsSinceEpoch(
              cleaningItem.data['dateFrom']),
          dateTo:
              DateTime.fromMillisecondsSinceEpoch(cleaningItem.data['dateTo']),
          authorId: cleaningItem.data['authorId'],
        ));
      });
      loadedCleaningItems.sort(
        (a, b) => a.dateFrom.compareTo(b.dateFrom) == 0
            ? a.dateTo.compareTo(b.dateTo)
            : a.dateFrom.compareTo(b.dateFrom),
      );
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

  // function which adds a cleaning item to a resident association.
  Future<void> addCleaningItem(
      String residentAssociationId, Cleaning cleaningItem) async {
    try {
      final response = await _associationsRef
          .document(residentAssociationId)
          .collection("CleaningItems")
          .add({
        'apartment': cleaningItem.apartment,
        'dateFrom': cleaningItem.dateFrom.millisecondsSinceEpoch,
        'dateTo': cleaningItem.dateTo.millisecondsSinceEpoch,
        'authorId': cleaningItem.authorId,
      });
      final newCleaningItem = Cleaning(
        apartment: cleaningItem.apartment,
        dateFrom: cleaningItem.dateFrom,
        dateTo: cleaningItem.dateTo,
        authorId: cleaningItem.authorId,
        id: response.documentID,
      );
      _cleaningItems.add(newCleaningItem);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which deletes a cleaning item in a resident association.
  Future<void> deleteCleaningItem(
      String residentAssociationId, String cleaningId) async {
    final deleteIndex = _cleaningItems
        .indexWhere((cleaningItem) => cleaningItem.id == cleaningId);
    var deletedCleaningItem = _cleaningItems[deleteIndex];
    _cleaningItems.removeAt(deleteIndex);
    notifyListeners();
    try {
      await _associationsRef
          .document(residentAssociationId)
          .collection('CleaningItems')
          .document(cleaningId)
          .delete();
      deletedCleaningItem = null;
    } catch (error) {
      _cleaningItems.insert(deleteIndex, deletedCleaningItem);
      notifyListeners();
    }
  }

  // function which returns the cleaning item which has the id taken in as
  // parameter, if found.
  Cleaning findById(String id) {
    return _cleaningItems.firstWhere((cleaning) => cleaning.id == id);
  }

  // functions which updates a cleaning item in a resident association.
  Future<void> updateCleaningItem(
      String residentAssociationId, Cleaning editedCleaning) async {
    try {
      await _associationsRef
          .document(residentAssociationId)
          .collection('CleaningItems')
          .document(editedCleaning.id)
          .updateData({
        'apartment': editedCleaning.apartment,
        'dateFrom': editedCleaning.dateFrom.millisecondsSinceEpoch,
        'dateTo': editedCleaning.dateTo.millisecondsSinceEpoch,
        'authorId': editedCleaning.authorId,
      });
      final cleaningIndex = _cleaningItems
          .indexWhere((cleaning) => cleaning.id == editedCleaning.id);
      if (cleaningIndex >= 0) {
        _cleaningItems[cleaningIndex] = editedCleaning;
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // functions which filters whether a cleaning item is ahead, old or currently
  // taking place.
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

  // function which returns a list of cleaning items which contain the the search
  // query and match a given status filter (ahead, old or current).
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

  // function which fetches cleaning task items of a resident association and
  // stores them in the _cleaningTasks list.
  Future<void> fetchCleaningTasks(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationsRef
          .document(residentAssociationId)
          .collection('CleaningTasks')
          .getDocuments();
      final List<CleaningTask> loadedCleaningTask = [];
      response.documents.forEach((cleaningTask) {
        loadedCleaningTask.add(CleaningTask(
          id: cleaningTask.documentID,
          title: cleaningTask.data['title'],
          description: cleaningTask.data['description'],
          taskDone: cleaningTask.data['taskDone'],
        ));
      });
      _cleaningTasks = loadedCleaningTask;
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

  // function which adds a cleaning task to a resident association.
  Future<void> addCleaningTaskItem(
      String residentAssociationId, CleaningTask cleaningTaskItem) async {
    try {
      final response = await _associationsRef
          .document(residentAssociationId)
          .collection("CleaningTasks")
          .add({
        'title': cleaningTaskItem.title,
        'description': cleaningTaskItem.description,
        'taskDone': cleaningTaskItem.taskDone,
      });
      final newCleaningTaskItem = CleaningTask(
        title: cleaningTaskItem.title,
        description: cleaningTaskItem.description,
        taskDone: cleaningTaskItem.taskDone,
        id: response.documentID,
      );
      _cleaningTasks.add(newCleaningTaskItem);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which updates a cleaning task item in a resident association.
  Future<void> updateCleaningTaskItem(
      String residentAssociationId, CleaningTask editedCleaningTask) async {
    final cleaningTaskIndex = _cleaningTasks
        .indexWhere((cleaningTask) => cleaningTask.id == editedCleaningTask.id);
    if (cleaningTaskIndex >= 0) {
      _cleaningTasks[cleaningTaskIndex] = editedCleaningTask;
    }
    try {
      await _associationsRef
          .document(residentAssociationId)
          .collection('CleaningTasks')
          .document(editedCleaningTask.id)
          .updateData({
        'title': editedCleaningTask.title,
        'taskDone': editedCleaningTask.taskDone,
        'description': editedCleaningTask.description,
      });
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // functions which returns a cleaning task which has the id taken in as
  // parameter, if found.
  CleaningTask findCleaningTaskById(String id) {
    return _cleaningTasks.firstWhere((cleaningTask) => cleaningTask.id == id);
  }

  // function which deletes a cleaning task item of a resident association.
  Future<void> deleteCleaningTaskItem(
      String residentAssociationId, String cleaningTaskId) async {
    final deleteIndex = _cleaningTasks
        .indexWhere((cleaningTask) => cleaningTask.id == cleaningTaskId);
    var deletedCleaningItem = _cleaningTasks[deleteIndex];
    _cleaningTasks.removeAt(deleteIndex);
    notifyListeners();
    try {
      await _associationsRef
          .document(residentAssociationId)
          .collection('CleaningTasks')
          .document(cleaningTaskId)
          .delete();
      deletedCleaningItem = null;
    } catch (error) {
      _cleaningTasks.insert(deleteIndex, deletedCleaningItem);
      notifyListeners();
    }
  }

  // function which returns all cleaning tasks of a given resident assocation.
  List<CleaningTask> getAllTasks() {
    return [..._cleaningTasks];
  }
}
