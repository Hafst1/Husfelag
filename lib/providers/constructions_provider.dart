import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/construction.dart';
import '../shared/constants.dart' as Constants;

enum ConstructionStatus { current, ahead, old }

class ConstructionsProvider with ChangeNotifier {

  // list of constructions for a resident association.
  @visibleForTesting
  List<Construction> constructions = [];

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);

  // function which fetches the constructions of a resident association
  // and stores them in the _constructions list.
  Future<void> fetchConstructions(String residentAssociationId) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.CONSTRUCTIONS_COLLECTION)
          .getDocuments();
      final List<Construction> loadedConstructions = [];
      response.documents.forEach((construction) {
        loadedConstructions.add(Construction(
          id: construction.documentID,
          title: construction.data[Constants.TITLE],
          dateFrom: DateTime.fromMillisecondsSinceEpoch(
              construction.data[Constants.DATE_FROM]),
          dateTo: DateTime.fromMillisecondsSinceEpoch(
              construction.data[Constants.DATE_TO]),
          description: construction.data[Constants.DESCRIPTION],
          authorId: construction.data[Constants.AUTHOR_ID],
        ));
      });
      constructions = loadedConstructions;
      sortConstructions();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which adds a construction to a resident association.
  Future<void> addConstruction(
      String residentAssociationId, Construction construction) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.CONSTRUCTIONS_COLLECTION)
          .add({
        Constants.TITLE: construction.title,
        Constants.DATE_FROM: construction.dateFrom.millisecondsSinceEpoch,
        Constants.DATE_TO: construction.dateTo.millisecondsSinceEpoch,
        Constants.DESCRIPTION: construction.description,
        Constants.AUTHOR_ID: construction.authorId,
      });
      final newConstruction = Construction(
        title: construction.title,
        dateFrom: construction.dateFrom,
        dateTo: construction.dateTo,
        description: construction.description,
        authorId: construction.authorId,
        id: response.documentID,
      );
      constructions.add(newConstruction);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which deletes a construction from a resident association.
  Future<void> deleteConstruction(
      String residentAssociationId, String constructionId) async {
    final deleteIndex = constructions
        .indexWhere((construction) => construction.id == constructionId);
    var deletedConstruction = constructions[deleteIndex];
    constructions.removeAt(deleteIndex);
    notifyListeners();
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection(Constants.CONSTRUCTIONS_COLLECTION)
          .document(constructionId)
          .delete();
      deletedConstruction = null;
    } catch (error) {
      constructions.insert(deleteIndex, deletedConstruction);
      notifyListeners();
    }
  }

  // function which returns a construction which has the id taken in as
  // parameter, if found.
  Construction findById(String id) {
    return constructions.firstWhere((construction) => construction.id == id);
  }

  // function which updates a construction in a resident association.
  Future<void> updateConstruction(
      String residentAssociationId, Construction editedConstruction) async {
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection(Constants.CONSTRUCTIONS_COLLECTION)
          .document(editedConstruction.id)
          .updateData({
        Constants.TITLE: editedConstruction.title,
        Constants.DATE_FROM: editedConstruction.dateFrom.millisecondsSinceEpoch,
        Constants.DATE_TO: editedConstruction.dateTo.millisecondsSinceEpoch,
        Constants.DESCRIPTION: editedConstruction.description,
        Constants.AUTHOR_ID: editedConstruction.authorId,
      });
      final constructionIndex = constructions.indexWhere(
          (construction) => construction.id == editedConstruction.id);
      if (constructionIndex >= 0) {
        final oldConstruction = constructions[constructionIndex];
        constructions[constructionIndex] = editedConstruction;

        // if the either of the dates have changed we have to sort the list again.
        if (oldConstruction.dateFrom != editedConstruction.dateFrom ||
            oldConstruction.dateTo != editedConstruction.dateTo) {
          sortConstructions();
        }
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // functions which filters constructions whether they are ahead, old or currently taking place.
  bool constructionStatusFilter(
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
    List<Construction> constructionsList = [...constructions];
    String searchQuery = query.toLowerCase();
    List<Construction> displayList = [];
    if (query.isNotEmpty) {
      constructionsList.forEach((item) {
        if (item.title.toLowerCase().contains(searchQuery) &&
            constructionStatusFilter(
              filterIndex,
              item.dateFrom,
              item.dateTo,
            )) {
          displayList.add(item);
        }
      });
    } else {
      constructionsList.forEach((item) {
        if (constructionStatusFilter(
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

  // function which sorts the constructions list by the dateFrom property, if
  // equal the items are sorted by the dateTo property.
  void sortConstructions() {
    constructions.sort(
      (a, b) => a.dateFrom.compareTo(b.dateFrom) == 0
          ? a.dateTo.compareTo(b.dateTo)
          : a.dateFrom.compareTo(b.dateFrom),
    );
  }

  // function which returns all constructions.
  List<Construction> getAllConstructions() {
    return [...constructions];
  }
}
