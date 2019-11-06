import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/construction.dart';
import '../services/api.dart';

class CRUDModel extends ChangeNotifier {
  Api _api = new Api("CleaningTasks");

  List<Construction> products;
  QuerySnapshot constructions;

  Future<List<Construction>> fetchProducts() async {
    var result = await _api.getDataCollection();
    products = result.documents
        .map((doc) => Construction.fromMap(doc.data, doc.documentID))
        .toList();
    return products;
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


}