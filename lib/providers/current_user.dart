import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser with ChangeNotifier {
  var _id = '';
  var _email = '';
  var _name = '';
  var _home = '';
  var _residentAssociationNumber = '';

  Future<void> fetchCurrentUser(String id) async {
    DocumentReference userRef = Firestore.instance
        .collection("user")
        .document(id);
    try {
      final fetchedUser = await userRef.get();
      _id = fetchedUser.documentID;
      _email = fetchedUser.data['email'];
      _name = fetchedUser.data['name'];
      _home = fetchedUser.data['home'];
      _residentAssociationNumber = fetchedUser.data['residentAssociationNumber'];
    } catch (error) {
      _id = id;
    }
  }

  // Future<void> fetchAssociations() {
  //   DocumentReference documentRef = Firestore.instance
  //       .collection("ResidentAssociation");
  // }

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