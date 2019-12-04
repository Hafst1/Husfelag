import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cleaning_task.dart';
import '../models/cleaning.dart';
import '../shared/constants.dart' as Constants;

enum CleaningStatus { current, ahead, old }

class CleaningProvider with ChangeNotifier {
  List<Cleaning> _cleaningItems = [];
  List<CleaningTask> _cleaningTasks = [];

  // collection reference to resident associations.
  CollectionReference _associationsRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);

  // function which fetches cleaning items of a resident association
  // and stores them in the _cleaningItems list.
  Future<void> fetchCleaningItems(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationsRef
          .document(residentAssociationId)
          .collection(Constants.CLEANING_ITEMS_COLLECTION)
          .getDocuments();
      final List<Cleaning> loadedCleaningItems = [];
      response.documents.forEach((cleaningItem) {
        loadedCleaningItems.add(Cleaning(
          id: cleaningItem.documentID,
          apartmentNumber: cleaningItem.data[Constants.APARTMENT_NUMBER],
          dateFrom: DateTime.fromMillisecondsSinceEpoch(
              cleaningItem.data[Constants.DATE_FROM]),
          dateTo: DateTime.fromMillisecondsSinceEpoch(
              cleaningItem.data[Constants.DATE_TO]),
          authorId: cleaningItem.data[Constants.AUTHOR_ID],
        ));
      });
      _cleaningItems = loadedCleaningItems;
      sortCleaningItems();
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
          .collection(Constants.CLEANING_ITEMS_COLLECTION)
          .add({
        Constants.APARTMENT_NUMBER: cleaningItem.apartmentNumber,
        Constants.DATE_FROM: cleaningItem.dateFrom.millisecondsSinceEpoch,
        Constants.DATE_TO: cleaningItem.dateTo.millisecondsSinceEpoch,
        Constants.AUTHOR_ID: cleaningItem.authorId,
      });
      final newCleaningItem = Cleaning(
        apartmentNumber: cleaningItem.apartmentNumber,
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
          .collection(Constants.CLEANING_ITEMS_COLLECTION)
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
          .collection(Constants.CLEANING_ITEMS_COLLECTION)
          .document(editedCleaning.id)
          .updateData({
        Constants.APARTMENT_NUMBER: editedCleaning.apartmentNumber,
        Constants.DATE_FROM: editedCleaning.dateFrom.millisecondsSinceEpoch,
        Constants.DATE_TO: editedCleaning.dateTo.millisecondsSinceEpoch,
        Constants.AUTHOR_ID: editedCleaning.authorId,
      });
      final cleaningIndex = _cleaningItems
          .indexWhere((cleaning) => cleaning.id == editedCleaning.id);
      if (cleaningIndex >= 0) {
        final oldCleaningItem = _cleaningItems[cleaningIndex];
        _cleaningItems[cleaningIndex] = editedCleaning;

        // if dates have changed we have to sort the list of cleaning items again.
        if (oldCleaningItem.dateFrom != editedCleaning.dateFrom ||
            oldCleaningItem.dateTo != editedCleaning.dateTo) {
          sortCleaningItems();
        }
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
        if (item.apartmentNumber.toLowerCase().contains(searchQuery) &&
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

  // functions which checks whether it is the user's turn to clean. If
  // the function returns true he will be able to check the boxes of
  // the cleaning task list.
  bool isUsersTurnToClean(String apartment) {
    if (_cleaningItems.isEmpty) {
      return false;
    }
    DateTime exactDate = DateTime.now();
    DateTime startOfCurrentDate =
        DateTime(exactDate.year, exactDate.month, exactDate.day, 0, 0, 0, 0);
    DateTime endOfCurrentDate = DateTime(
        exactDate.year, exactDate.month, exactDate.day, 23, 59, 59, 999);
    var retVal = false;
    for (final cleaningItem in _cleaningItems) {
      if (cleaningItem.dateFrom.isAfter(endOfCurrentDate)) {
        break;
      }
      if (cleaningItem.apartmentNumber != apartment) {
        continue;
      }
      if (cleaningItem.dateFrom.isBefore(endOfCurrentDate) &&
          (cleaningItem.dateTo.compareTo(startOfCurrentDate) == 0 ||
              cleaningItem.dateTo.isAfter(startOfCurrentDate))) {
        retVal = true;
        break;
      }
    }
    return retVal;
  }

  // functions which sorts the cleaning item list by the dateFrom property,
  // if equal it is ordered by the dateTo property.
  void sortCleaningItems() {
    _cleaningItems.sort(
      (a, b) => a.dateFrom.compareTo(b.dateFrom) == 0
          ? a.dateTo.compareTo(b.dateTo)
          : a.dateFrom.compareTo(b.dateFrom),
    );
  }

  // function which fetches cleaning task items of a resident association and
  // stores them in the _cleaningTasks list.
  Future<void> fetchCleaningTasks(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationsRef
          .document(residentAssociationId)
          .collection(Constants.CLEANING_TASKS_COLLECTION)
          .getDocuments();
      final List<CleaningTask> loadedCleaningTask = [];
      response.documents.forEach((cleaningTask) {
        loadedCleaningTask.add(CleaningTask(
          id: cleaningTask.documentID,
          title: cleaningTask.data[Constants.TITLE],
          description: cleaningTask.data[Constants.DESCRIPTION],
          taskDone: cleaningTask.data[Constants.TASK_DONE],
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
          .collection(Constants.CLEANING_TASKS_COLLECTION)
          .add({
        Constants.TITLE: cleaningTaskItem.title,
        Constants.DESCRIPTION: cleaningTaskItem.description,
        Constants.TASK_DONE: cleaningTaskItem.taskDone,
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
          .collection(Constants.CLEANING_TASKS_COLLECTION)
          .document(editedCleaningTask.id)
          .updateData({
        Constants.TITLE: editedCleaningTask.title,
        Constants.DESCRIPTION: editedCleaningTask.description,
        Constants.TASK_DONE: editedCleaningTask.taskDone,
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
          .collection(Constants.CLEANING_TASKS_COLLECTION)
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

  // function which returns all cleaning items.
  List<Cleaning> getAllCleaningItems() {
    return [..._cleaningItems];
  }
}
