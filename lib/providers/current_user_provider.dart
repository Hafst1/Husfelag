import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/resident_association.dart';
import '../models/apartment.dart';
import '../models/user.dart';
import '../services/database.dart';

class CurrentUserProvider with ChangeNotifier {
  var _currentUser = UserData(
    id: '',
    email: '',
    name: '',
    residentAssociationId: '',
    apartmentId: '',
    isAdmin: false,
  );

  List<ResidentAssociation> _residentAssociations = [];
  List<Apartment> _apartments = [];

  CollectionReference _associationRef =
      Firestore.instance.collection('ResidentAssociation');
  CollectionReference _userRef = Firestore.instance.collection('user');

  // fetch user when starting application and store in the variables above.
  Future<void> fetchCurrentUser(String id) async {
    try {
      final fetchedUser = await _userRef.document(id).get();
      _currentUser = UserData(
        id: fetchedUser.documentID,
        email: fetchedUser.data['email'],
        name: fetchedUser.data['name'],
        residentAssociationId: fetchedUser.data['residentAssociationId'],
        apartmentId: fetchedUser['apartmentId'],
        isAdmin: false,
      );
      // _id = fetchedUser.documentID;
      // _email = fetchedUser.data['email'];
      // _name = fetchedUser.data['name'];
      // _home = fetchedUser.data['home'];
      // _residentAssociationNumber =
      //     fetchedUser.data['residentAssociationId'];
      // _apartmentId = fetchedUser['apartmentId'];
    } catch (error) {
      print(error);
      // error handling vantar
    }
  }

  // fetch associations from firebase and store in _residentAssociation list.
  Future<void> fetchAssociations(BuildContext context) async {
    List<ResidentAssociation> loadedAssociations = [];
    try {
      final response = await _associationRef.getDocuments();
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

  // function for creating a resident association which also adds apartment
  // to it and updates user info on firebase.
  Future<String> createAssociation(
      ResidentAssociation association, Apartment apartment) async {
    try {
      final response = await _associationRef.add({
        'address': association.address,
        'description': association.description,
        'accessCode': association.accessCode,
      });
      await _associationRef.document(response.documentID).updateData({
        'address': association.address,
        'description': association.description,
        'accessCode': response.documentID,
      });
      final apartmentId = await _associationRef
          .document(response.documentID)
          .collection('Apartments')
          .add({
        'apartmentNumber': apartment.apartmentNumber,
        'accessCode': apartment.accessCode,
        'residents': [_currentUser.id],
      });
      await DatabaseService(uid: _currentUser.id).updateUserData(
        // _name,
        // _email,
        // _home,
        // apartmentId.documentID,
        // response.documentID,
        _currentUser.name,
        _currentUser.email,
        response.documentID,
        apartmentId.documentID,
        true,
      );
      return response.documentID;
    } catch (error) {
      throw (error);
    }
  }

  // function which checks whether an association address is available or not.
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

  // function which fetches apartments from firebase and stores them in the
  // _apartments list in the provider.
  Future<void> fetchApartments(String residentAssociationId) async {
    List<Apartment> loadedApartments = [];
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection('Apartments')
          .getDocuments();
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

  // function which adds an apartment to a resident association on firebase.
  Future<void> addApartment(
      String residentAssociationId, Apartment apartment) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection('Apartments')
          .add({
        'apartmentNumber': apartment.apartmentNumber,
        'accessCode': apartment.accessCode,
        'residents': apartment.residents,
      });
      await DatabaseService(uid: _currentUser.id).updateUserData(
        _currentUser.name,
        _currentUser.email,
        residentAssociationId,
        response.documentID,
        _currentUser.isAdmin,
        // _name,
        // _email,
        // _home,
        // response.documentID,
        // residentAssociationId,
      );
    } catch (error) {
      throw (error);
    }
  }

  // function which adds resident to an apartment of a resident
  // association on firebase.
  Future<void> joinApartment(
      String residentAssociationId, String apartmentId) async {
    final apartment =
        _apartments.firstWhere((apartment) => apartment.id == apartmentId);
    apartment.residents.add(_currentUser.id);
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection('Apartments')
          .document(apartmentId)
          .updateData({
        'apartmentNumber': apartment.apartmentNumber,
        'accessCode': apartment.accessCode,
        'residents': apartment.residents,
      });
      await DatabaseService(uid: _currentUser.id).updateUserData(
        _currentUser.name,
        _currentUser.email,
        residentAssociationId,
        apartmentId,
        _currentUser.isAdmin,
        // _name,
        // _email,
        // _home,
        // apartmentId,
        // residentAssociationId,
      );
    } catch (error) {
      throw (error);
    }
  }

  // getter for the apartments list.
  List<Apartment> getApartments() {
    return [..._apartments];
  }

  // function which checks whether an apartment number is available or not.
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

  // function which returns an association list filtered by the search query
  // taken in as parameter.
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

  // function which checks whether the user is part of a resident association or not.
  bool containsRAN() {
    return _currentUser.residentAssociationId != '';
  }

  // getter for the user id.
  String getId() {
    return _currentUser.id;
  }

  // getter for the user email.
  String getEmail() {
    return _currentUser.email;
  }

  // getter for the user name.
  String getName() {
    return _currentUser.name;
  }

  // getter for the user resident assocation number.
  String getResidentAssociationId() {
    return _currentUser.residentAssociationId;
  }

  // getter for the user apartment id.
  String getApartmentId() {
    return _currentUser.apartmentId;
  }

  // setter for the user resident association number.
  void setResidentAssociationId(String residentAssociationId) {
    _currentUser = UserData(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      residentAssociationId: residentAssociationId,
      apartmentId: _currentUser.apartmentId,
      isAdmin: _currentUser.isAdmin,
    );
  }

  // setter for the user apartment id.
  void setApartmentId(String apartmentId) {
    _currentUser = UserData(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      residentAssociationId: _currentUser.residentAssociationId,
      apartmentId: apartmentId,
      isAdmin: _currentUser.isAdmin,
    );
  }
}
