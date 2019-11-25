import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/construction.dart';
import '../services/api.dart';

enum ConstructionStatus { current, ahead, old }

class ConstructionsProvider with ChangeNotifier {

  Api _api = new Api("ConstructionItems");

  List<Construction> _constructionItems;
  QuerySnapshot constructions;

  Future<List<Construction>> fetchProducts() async {
    var result = await _api.getDataCollection();
    _constructionItems = result.documents
        .map((doc) => Construction.fromMap(doc.data, doc.documentID))
        .toList();
    return _constructionItems;
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Construction> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Construction.fromMap(doc.data, doc.documentID) ;
  }


  Future removeProduct(String id) async{
     await _api.removeDocument(id) ;
     return ;
  }
  Future updateProduct(Construction data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addProduct(Construction data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return ;

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

  List<Construction> getAllItemsForCalendar() {
    return null;
  }
  

  List<Construction> filteredItems(String query, int filterIndex) {
    List<Construction> constructions = [..._constructionItems];
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
    _constructionItems.add(newConstruction);
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
    _constructionItems.removeWhere((construction) => construction.id == id);
    notifyListeners();
  }

  Construction findById(String id) {
    return _constructionItems.firstWhere((construction) => construction.id == id);
  }
  
}
