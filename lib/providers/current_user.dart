import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/resident_association.dart';

class CurrentUser with ChangeNotifier {
  String _id = '';
  String _email = '';
  String _name = '';
  String _home = '';
  String _residentAssociationNumber = '';

  List<ResidentAssociation> _residentAssociations = [];

  Future<void> fetchCurrentUser(String id) async {
    DocumentReference userRef =
        Firestore.instance.collection("user").document(id);
    try {
      final fetchedUser = await userRef.get();
      _id = fetchedUser.documentID;
      _email = fetchedUser.data['email'];
      _name = fetchedUser.data['name'];
      _home = fetchedUser.data['home'];
      _residentAssociationNumber =
          fetchedUser.data['residentAssociationNumber'];
    } catch (error) {
      _id = id;
    }
  }

  Future<void> fetchAssociations() async {
    CollectionReference associatonRef =
        Firestore.instance.collection("ResidentAssociation");
    try {
      final response = await associatonRef.getDocuments();
      response.documents.forEach((association) {
        print(association);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> createAssociation() async {
    try {

    } catch (error) {
      
    }
  }

  String getId() {
    return _id;
  }

  String getEmail() {
    return _email;
  }

  String getName() {
    return _name;
  }

  String getHome() {
    return _home;
  }

  String getResidentAssociationNumber() {
    return _residentAssociationNumber;
  }

  void setId(String id) {
    _id = id;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setName(String name) {
    _name = name;
  }

  void setHome(String home) {
    _home = home;
  }

  void setResidentAssociationNumber(String residentAssociationNumber) {
    _residentAssociationNumber = residentAssociationNumber;
  }

  bool containsRAN() {
    return _residentAssociationNumber != '';
  }
}
