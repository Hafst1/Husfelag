import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/resident_association.dart';
import '../models/apartment.dart';
import '../models/user.dart';
import '../services/database.dart';
import '../shared/constants.dart' as Constants;

class AssociationsProvider with ChangeNotifier {
  // list of all resident associations.
  List<ResidentAssociation> _residentAssociations = [];
  // list of apartments to pick from when joining an association.
  List<Apartment> _apartments = [];
  // residents of logged in user's association.
  List<UserData> _residents = [];

  // references to the resident associations and users collections.
  CollectionReference _associationRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);
  CollectionReference _userRef =
      Firestore.instance.collection(Constants.USERS_COLLECTION);

  // functions which fetches residents of the logged in user's association.
  Future<void> fetchResidents(String residentAssociationId) async {
    try {
      final response = await _userRef
          .where(
            Constants.RESIDENT_ASSOCIATION_ID,
            isEqualTo: residentAssociationId,
          )
          .getDocuments();
      List<UserData> loadedResidents = [];
      response.documents.forEach((resident) {
        loadedResidents.add(UserData(
          id: resident.documentID,
          name: resident.data[Constants.NAME],
          email: resident.data[Constants.EMAIL],
          residentAssociationId:
              resident.data[Constants.RESIDENT_ASSOCIATION_ID],
          apartmentId: resident.data[Constants.APARTMENT_ID],
          isAdmin: resident.data[Constants.IS_ADMIN],
        ));
      });
      loadedResidents.sort((a, b) => a.name.compareTo(b.name));
      _residents = loadedResidents;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> makeUserAdmin(UserData user) async {
    try {
      await DatabaseService(uid: user.id).updateUserData(
        user.name,
        user.email,
        user.residentAssociationId,
        user.apartmentId,
        true,
      );
      final residentIndex =
          _residents.indexWhere((resident) => resident.id == user.id);
      if (residentIndex >= 0) {
        _residents[residentIndex] = UserData(
          id: user.id,
          name: user.name,
          email: user.email,
          residentAssociationId: user.residentAssociationId,
          apartmentId: user.apartmentId,
          isAdmin: true,
        );
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // functions which kicks user out of the resident association.
  Future<void> kickUser(UserData user, Apartment apartment) async {
    final deleteIndex =
        _residents.indexWhere((resident) => resident.id == user.id);
    var deletedResident = _residents[deleteIndex];
    _residents.removeAt(deleteIndex);
    notifyListeners();
    try {
      if (apartment.residents.length <= 1) {
        await _associationRef
            .document(user.residentAssociationId)
            .collection(Constants.APARTMENTS_COLLECTION)
            .document(apartment.id)
            .delete();
      } else {
        var updatedResidentList = apartment.residents;
        updatedResidentList.removeWhere((residentId) => residentId == user.id);
        await _associationRef
            .document(user.residentAssociationId)
            .collection(Constants.APARTMENTS_COLLECTION)
            .document(apartment.id)
            .updateData({
          Constants.APARTMENT_NUMBER: apartment.apartmentNumber,
          Constants.ACCESS_CODE: apartment.accessCode,
          Constants.RESIDENTS: updatedResidentList,
        });
      }
      await DatabaseService(uid: user.id).updateUserData(
        user.name,
        user.email,
        '',
        '',
        false,
      );
    } catch (error) {
      _residents.insert(deleteIndex, deletedResident);
      notifyListeners();
      throw (error);
    }
  }

  // function which returns the residents of the association.
  List<UserData> getResidentsOfAssociation() {
    return [..._residents];
  }

  UserData getResident(String userId) {
    final residentIndex =
        _residents.indexWhere((resident) => resident.id == userId);
    if (residentIndex >= 0) {
      return _residents[residentIndex];
    }
    return UserData(
      id: '',
      email: '',
      name: '',
      residentAssociationId: '',
      apartmentId: '',
      isAdmin: false,
    );
  }

  // fetch associations from firebase and store in _residentAssociation list.
  Future<void> fetchAssociations() async {
    List<ResidentAssociation> loadedAssociations = [];
    try {
      final response =
          await _associationRef.orderBy(Constants.ADDRESS).getDocuments();
      response.documents.forEach((association) {
        loadedAssociations.add(ResidentAssociation(
          id: association.documentID,
          address: association.data[Constants.ADDRESS],
          description: association.data[Constants.DESCRIPTION],
          accessCode: association.data[Constants.ACCESS_CODE],
        ));
      });
      _residentAssociations = loadedAssociations;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function for creating a resident association which also adds apartment
  // to it and updates user info on firebase.
  Future<String> createAssociation(ResidentAssociation association,
      Apartment apartment, UserData user) async {
    try {
      final response = await _associationRef.add({
        Constants.ADDRESS: association.address,
        Constants.DESCRIPTION: association.description,
        Constants.ACCESS_CODE: association.accessCode,
      });
      await _associationRef.document(response.documentID).updateData({
        Constants.ADDRESS: association.address,
        Constants.DESCRIPTION: association.description,
        Constants.ACCESS_CODE: response.documentID,
      });
      final apartmentId = await _associationRef
          .document(response.documentID)
          .collection(Constants.APARTMENTS_COLLECTION)
          .add({
        Constants.APARTMENT_NUMBER: apartment.apartmentNumber,
        Constants.ACCESS_CODE: apartment.accessCode,
        Constants.RESIDENTS: [user.id],
      });
      await DatabaseService(uid: user.id).updateUserData(
        user.name,
        user.email,
        response.documentID,
        apartmentId.documentID,
        true,
      );
      return response.documentID;
    } catch (error) {
      throw (error);
    }
  }

  // function which fetches the association of a user.
  Future<void> fetchAssociation(String residentAssociationId) async {
    try {
      final response =
          await _associationRef.document(residentAssociationId).get();
      var association = ResidentAssociation(
        id: response.documentID,
        address: response.data[Constants.ADDRESS],
        description: response.data[Constants.DESCRIPTION],
        accessCode: response.data[Constants.ACCESS_CODE],
      );
      _residentAssociations = [association];
    } catch (error) {
      throw (error);
    }
  }

  // function which updates a resident association's information.
  Future<void> updateAssociation(ResidentAssociation association) async {
    try {
      await _associationRef.document(association.id).updateData({
        Constants.ADDRESS: association.address,
        Constants.ACCESS_CODE: association.accessCode,
        Constants.DESCRIPTION: association.description,
      });
      final associationIndex = _residentAssociations
          .indexWhere((resAssociation) => resAssociation.id == association.id);
      if (associationIndex >= 0) {
        _residentAssociations[associationIndex] = association;
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which returns the resident association of a user.
  ResidentAssociation getAssociationOfUser(String residentAssociationId) {
    final associationIndex = _residentAssociations
        .indexWhere((association) => association.id == residentAssociationId);
    if (associationIndex >= 0) {
      return _residentAssociations[associationIndex];
    }
    return ResidentAssociation(
      id: '',
      address: '',
      description: '',
      accessCode: '',
    );
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

  // _apartments list in the provider.
  Future<void> fetchApartments(String residentAssociationId) async {
    List<Apartment> loadedApartments = [];
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.APARTMENTS_COLLECTION)
          .orderBy(Constants.APARTMENT_NUMBER)
          .getDocuments();
      response.documents.forEach((apartment) {
        loadedApartments.add(Apartment(
          id: apartment.documentID,
          apartmentNumber: apartment.data[Constants.APARTMENT_NUMBER],
          accessCode: apartment.data[Constants.ACCESS_CODE],
          residents: List.from(apartment.data[Constants.RESIDENTS]),
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
    String residentAssociationId,
    Apartment apartment,
    UserData user,
  ) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.APARTMENTS_COLLECTION)
          .add({
        Constants.APARTMENT_NUMBER: apartment.apartmentNumber,
        Constants.ACCESS_CODE: apartment.accessCode,
        Constants.RESIDENTS: apartment.residents,
      });
      await DatabaseService(uid: user.id).updateUserData(
        user.name,
        user.email,
        residentAssociationId,
        response.documentID,
        user.isAdmin,
      );
    } catch (error) {
      throw (error);
    }
  }

  // function which adds resident to an apartment of a resident
  // association on firebase.
  Future<void> joinApartment(
    String residentAssociationId,
    String apartmentId,
    UserData user,
  ) async {
    final apartment =
        _apartments.firstWhere((apartment) => apartment.id == apartmentId);
    apartment.residents.add(user.id);
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection(Constants.APARTMENTS_COLLECTION)
          .document(apartmentId)
          .updateData({
        Constants.APARTMENT_NUMBER: apartment.apartmentNumber,
        Constants.ACCESS_CODE: apartment.accessCode,
        Constants.RESIDENTS: apartment.residents,
      });
      await DatabaseService(uid: user.id).updateUserData(
        user.name,
        user.email,
        residentAssociationId,
        apartmentId,
        user.isAdmin,
      );
    } catch (error) {
      throw (error);
    }
  }

  // getter for the apartments list.
  List<Apartment> getApartments() {
    return [..._apartments];
  }

  // function which returns a single apartment with the id taken as parameter.
  Apartment getApartmentById(String apartmentId) {
    final apartmentIndex =
        _apartments.indexWhere((apartment) => apartment.id == apartmentId);
    if (apartmentIndex >= 0) {
      return _apartments[apartmentIndex];
    }
    return Apartment(
      id: '',
      apartmentNumber: '',
      accessCode: '',
      residents: [],
    );
  }

  // function which returns a single apartment with the id taken as parameter.
  Apartment getApartmentByNumber(String apartmentNumber) {
    final apartmentIndex = _apartments.indexWhere(
        (apartment) => apartment.apartmentNumber == apartmentNumber);
    if (apartmentIndex >= 0) {
      return _apartments[apartmentIndex];
    }
    return Apartment(
      id: '',
      apartmentNumber: '',
      accessCode: '',
      residents: [],
    );
  }

  // function which gets the apartment number of the logged in user.
  String getApartmentNumber(String apartmentId) {
    if (_apartments.isEmpty) {
      return '';
    }
    var retVal = '';
    final apartmentIndex =
        _apartments.indexWhere((apartment) => apartment.id == apartmentId);
    if (apartmentIndex >= 0) {
      retVal = _apartments[apartmentIndex].apartmentNumber;
    }
    return retVal;
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

  // functions which returns true if there are more than one admin the resident
  // association, false otherwise.
  bool moreThanOneAdmin() {
    var numberOfAdmins = 0;
    for (final resident in _residents) {
      if (resident.isAdmin) {
        numberOfAdmins++;
      }
    }
    return numberOfAdmins > 1;
  }
}
