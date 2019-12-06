import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../models/apartment.dart';
import '../services/database.dart';
import '../shared/constants.dart' as Constants;

class CurrentUserProvider with ChangeNotifier {
  // logged in user.
  var _currentUser = UserData(
    id: '',
    email: '',
    name: '',
    residentAssociationId: '',
    apartmentId: '',
    isAdmin: false,
  );

  // reference to the resident associations and users collections.
  CollectionReference _associationsRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);
  CollectionReference _userRef =
      Firestore.instance.collection(Constants.USERS_COLLECTION);

  // fetch user when starting application and store in the _currentUser object.
  Future<void> fetchCurrentUser(String id) async {
    try {
      final fetchedUser = await _userRef.document(id).get();
      _currentUser = UserData(
        id: fetchedUser.documentID,
        email: fetchedUser.data[Constants.EMAIL],
        name: fetchedUser.data[Constants.NAME],
        residentAssociationId:
            fetchedUser.data[Constants.RESIDENT_ASSOCIATION_ID],
        apartmentId: fetchedUser[Constants.APARTMENT_ID],
        isAdmin: fetchedUser[Constants.IS_ADMIN],
      );
    } catch (error) {
      //error handling vantar
      print(error);
    }
  }

  // functions which makes the current user leave the resident association
  // he is registered in. If the user is the only resident in his apartment
  // then the apartment is deleted as well.
  Future<void> leaveResidentAssociation(Apartment apartment) async {
    try {
      if (apartment.residents.length <= 1) {
        await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.APARTMENTS_COLLECTION)
            .document(_currentUser.apartmentId)
            .delete();
      } else {
        var updatedResidentsList = apartment.residents;
        updatedResidentsList
            .removeWhere((residentId) => residentId == _currentUser.id);
        await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.APARTMENTS_COLLECTION)
            .document(_currentUser.apartmentId)
            .updateData({
          Constants.APARTMENT_NUMBER: apartment.apartmentNumber,
          Constants.ACCESS_CODE: apartment.accessCode,
          Constants.RESIDENTS: updatedResidentsList,
        });
      }
      await DatabaseService(uid: _currentUser.id)
          .updateUserData(_currentUser.name, _currentUser.email, '', '', false);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which returns the current user.
  UserData getUser() {
    return UserData(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      residentAssociationId: _currentUser.residentAssociationId,
      apartmentId: _currentUser.apartmentId,
      isAdmin: _currentUser.isAdmin,
    );
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

  // function which returns true if current user is admin, false otherwise.
  bool isAdmin() {
    return _currentUser.isAdmin;
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
