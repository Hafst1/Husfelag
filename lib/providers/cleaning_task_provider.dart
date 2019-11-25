import 'package:flutter/material.dart';
import '../models/cleaning_task.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api.dart';

class CleaningTaskProvider with ChangeNotifier {
  Api _api = new Api("CleaningTasks");

  List<CleaningTask> _cleaningTasks;
  QuerySnapshot cleaningTasks;

  Future<List<CleaningTask>> fetchProducts() async {
    var result = await _api.getDataCollection();
    _cleaningTasks = result.documents
        .map((doc) => CleaningTask.fromMap(doc.data, doc.documentID))
        .toList();
    return _cleaningTasks;
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<CleaningTask> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  CleaningTask.fromMap(doc.data, doc.documentID) ;
  }


  Future removeProduct(String id) async{
     await _api.removeDocument(id) ;
     return ;
  }
  Future updateProduct(CleaningTask data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addProduct(CleaningTask data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return ;

  }
  List<CleaningTask> get items {
    return [..._cleaningTasks];
  }
  
  List<CleaningTask> getAllTasks() {
    return [..._cleaningTasks];

  }
}

