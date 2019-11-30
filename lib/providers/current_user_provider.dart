import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/resident_association.dart';
import '../models/apartment.dart';
import '../services/database.dart';

class CurrentUserProvider with ChangeNotifier {
  String _id = '';
  String _email = '';
  String _name = '';
  String _home = '';
  String _residentAssociationNumber = '';
  String _apartmentId;

  List<ResidentAssociation> _residentAssociations = [];
  List<Apartment> _apartments = [];

  Future<void> fetchCurrentUser(String id) async {
    DocumentReference userRef =
        Firestore.instance.collection('user').document(id);
    try {
      final fetchedUser = await userRef.get();

      _id = fetchedUser.documentID;
      _email = fetchedUser.data['email'];
      _name = fetchedUser.data['name'];
      _home = fetchedUser.data['home'];
      _residentAssociationNumber =
          fetchedUser.data['residentAssociationNumber'];
      _apartmentId = fetchedUser['apartmentId'];
    } catch (error) {
      print(error);
      // error handling vantar
    }
  }

  Future<void> fetchAssociations(BuildContext context) async {
    CollectionReference associatonRef =
        Firestore.instance.collection('ResidentAssociation');
    List<ResidentAssociation> loadedAssociations = [];
    try {
      final response = await associatonRef.getDocuments();
      response.documents.forEach((association) {
        loadedAssociations.add(ResidentAssociation(
          id: association.documentID,
          address: association.data['address'],
          description: association.data['description'],
          accessCode: association.data['accessCode'],
        ));
      });
      _residentAssociations = loadedAssociations;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp húsfélögum!'),
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

  Future<String> createAssociation(
      ResidentAssociation association, Apartment apartment) async {
    CollectionReference associatonRef =
        Firestore.instance.collection('ResidentAssociation');
    try {
      final response = await associatonRef.add({
        'address': association.address,
        'description': association.description,
        'accessCode': association.accessCode,
      });
      await associatonRef.document(response.documentID).updateData({
        'address': association.address,
        'description': association.description,
        'accessCode': response.documentID,
      });
      final apartmentId = await associatonRef
          .document(response.documentID)
          .collection('Apartments')
          .add({
        'apartmentNumber': apartment.apartmentNumber,
        'accessCode': apartment.accessCode,
        'residents': [_id],
      });
      await DatabaseService(uid: _id).updateUserData(
        _name,
        _email,
        _home,
        apartmentId.documentID,
        response.documentID,
      );
      // mögulega notify listeners
      return response.documentID;
    } catch (error) {
      throw (error);
    }
  }

  bool associationAddressIsAvailable(String query) {
    String searchQuery = query.toLowerCase();
    bool retVal = true;
    for (final association in [..._residentAssociations]) {
      if (association.address.toLowerCase().compareTo(searchQuery) == 0) {
        retVal = false;
        break;
      }
    }
    return retVal;
  }

  Future<void> fetchApartments(String residentAssociationId) async {
    DocumentReference apartmentRef = Firestore.instance
        .collection('ResidentAssociation')
        .document(residentAssociationId);
    List<Apartment> loadedApartments = [];
    try {
      final response =
          await apartmentRef.collection('Apartments').getDocuments();
      response.documents.forEach((apartment) {
        loadedApartments.add(Apartment(
          id: apartment.documentID,
          apartmentNumber: apartment.data['apartmentNumber'],
          accessCode: apartment.data['accessCode'],
          residents: List.from(apartment.data['residents']),
        ));
      });
      _apartments = loadedApartments;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addApartment(
      String residentAssociationId, Apartment apartment) async {
    DocumentReference apartmentRef = Firestore.instance
        .collection('ResidentAssociation')
        .document(residentAssociationId);
    try {
      final response = await apartmentRef.collection('Apartments').add({
        'apartmentNumber': apartment.apartmentNumber,
        'accessCode': apartment.accessCode,
        'residents': apartment.residents,
      });
      await DatabaseService(uid: _id).updateUserData(
        _name,
        _email,
        _home,
        response.documentID,
        residentAssociationId,
      );
    } catch (error) {
      throw (error);
    }
  }

  Future<void> joinApartment(
      String residentAssociationId, String apartmentId) async {
    DocumentReference apartmentRef = Firestore.instance
        .collection('ResidentAssociation')
        .document(residentAssociationId);
    final apartment =
        _apartments.firstWhere((apartment) => apartment.id == apartmentId);
    apartment.residents.add(_id);
    try {
      await apartmentRef
          .collection('Apartments')
          .document(apartmentId)
          .updateData({
        'apartmentNumber': apartment.apartmentNumber,
        'accessCode': apartment.accessCode,
        'residents': apartment.residents,
      });
      await DatabaseService(uid: _id).updateUserData(
        _name,
        _email,
        _home,
        apartmentId,
        residentAssociationId,
      );
    } catch (error) {
      throw (error);
    }
  }

  List<Apartment> getApartments() {
    return [..._apartments];
  }

  bool apartmentIsAvailable(String query) {
    String searchQuery = query.toLowerCase();
    bool retVal = true;
    for (final apartment in [..._apartments]) {
      if (apartment.apartmentNumber.toLowerCase().compareTo(searchQuery) == 0) {
        retVal = false;
        break;
      }
    }
    return retVal;
  }

  List<ResidentAssociation> filteredItems(String query) {
    List<ResidentAssociation> associations = [..._residentAssociations];
    String searchQuery = query.toLowerCase();
    List<ResidentAssociation> displayList = [];
    if (query.isEmpty) {
      return associations;
    }
    associations.forEach((association) {
      if (association.address.toLowerCase().contains(searchQuery)) {
        displayList.add(association);
      }
    });
    return displayList;
  }

  bool containsRAN() {
    return _residentAssociationNumber != '';
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

  String getApartmentId() {
    return _apartmentId;
  }

  void setResidentAssociationNumber(String residentAssociationNumber) {
    _residentAssociationNumber = residentAssociationNumber;
  }

  void setApartmentId(String apartmentId) {
    _apartmentId = apartmentId;
  }
}
