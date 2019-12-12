import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    userToken: '',
  );

  // reference to the resident associations and users collections.
  CollectionReference _associationsRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);
  CollectionReference _userRef =
      Firestore.instance.collection(Constants.USERS_COLLECTION);
  StorageReference _storageRef = FirebaseStorage.instance.ref();

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
        userToken: fetchedUser[Constants.USER_TOKEN],
      );
    } catch (error) {
      // log the error instead of throwing it to futurebuilder.
      print(error);
    }
  }

  // functions which rebuilds widgets listening to current user provider.
  triggerCurrentUserRefresh() {
    notifyListeners();
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
      await DatabaseService(uid: _currentUser.id).updateUserData(
        _currentUser.name,
        _currentUser.email,
        '',
        '',
        false,
        _currentUser.userToken,
      );
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which deletes a resident association.
  Future<void> deleteResidentAssociation() async {
    try {
      // delete own apartment which is the only apartment left.
      await _associationsRef
          .document(_currentUser.residentAssociationId)
          .collection(Constants.APARTMENTS_COLLECTION)
          .document(_currentUser.apartmentId)
          .delete();

      // fetch and delete all constructions.
      final constructions = await _associationsRef
          .document(_currentUser.residentAssociationId)
          .collection(Constants.CONSTRUCTIONS_COLLECTION)
          .getDocuments();
      constructions.documents.forEach((document) async {
        await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.CONSTRUCTIONS_COLLECTION)
            .document(document.documentID)
            .delete();
      });

      // fetch and delete all meetings.
      final meetings = await _associationsRef
          .document(_currentUser.residentAssociationId)
          .collection(Constants.MEETINGS_COLLECTION)
          .getDocuments();
      meetings.documents.forEach((meeting) async {
        await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.MEETINGS_COLLECTION)
            .document(meeting.documentID)
            .delete();
      });

      // fetch and delete all cleaning items.
      final cleanings = await _associationsRef
          .document(_currentUser.residentAssociationId)
          .collection(Constants.CLEANING_ITEMS_COLLECTION)
          .getDocuments();
      cleanings.documents.forEach((cleaning) async {
        await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.CLEANING_ITEMS_COLLECTION)
            .document(cleaning.documentID)
            .delete();
      });

      // fetch and delete all cleaning tasks.
      final cleaningTasks = await _associationsRef
          .document(_currentUser.residentAssociationId)
          .collection(Constants.CLEANING_TASKS_COLLECTION)
          .getDocuments();
      cleaningTasks.documents.forEach((cleaningTask) async {
        await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.CLEANING_TASKS_COLLECTION)
            .document(cleaningTask.documentID)
            .delete();
      });

      // fetch all folders.
      final folders = await _associationsRef
          .document(_currentUser.residentAssociationId)
          .collection(Constants.FOLDERS_COLLECTION)
          .getDocuments();

      // iterate through the list of folders.
      folders.documents.forEach((folder) async {
        // fetch all documents of folder.
        final documentsOfFolder = await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.FOLDERS_COLLECTION)
            .document(folder.documentID)
            .collection(Constants.DOCUMENTS_COLLECTION)
            .getDocuments();

        // delete each document of folder in firebase storage and database.
        documentsOfFolder.documents.forEach((document) async {
          await _storageRef.child(document.data[Constants.FILE_NAME]).delete();
          await _associationsRef
              .document(_currentUser.residentAssociationId)
              .collection(Constants.FOLDERS_COLLECTION)
              .document(folder.documentID)
              .collection(Constants.DOCUMENTS_COLLECTION)
              .document(document.documentID)
              .delete();
        });

        // delete empty folder.
        await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.FOLDERS_COLLECTION)
            .document(folder.documentID)
            .delete();
      });

      // fetch delete all notifications.
      final notifications = await _associationsRef
          .document(_currentUser.residentAssociationId)
          .collection(Constants.NOTIFICATIONS_COLLECTION)
          .getDocuments();
      notifications.documents.forEach((notification) async {
        await _associationsRef
            .document(_currentUser.residentAssociationId)
            .collection(Constants.NOTIFICATIONS_COLLECTION)
            .document(notification.documentID)
            .delete();
      });

      // delete empty resident association.
      await _associationsRef
          .document(_currentUser.residentAssociationId)
          .delete();

      // update user information.
      await DatabaseService(uid: _currentUser.id).updateUserData(
        _currentUser.name,
        _currentUser.email,
        '',
        '',
        false,
        _currentUser.userToken,
      );
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
      userToken: _currentUser.userToken,
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
      userToken: _currentUser.userToken,
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
      userToken: _currentUser.userToken,
    );
  }
}
