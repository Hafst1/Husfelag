import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../shared/constants.dart' as Constants;

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference residentCollection =
      Firestore.instance.collection(Constants.USERS_COLLECTION);

  Future<void> updateUserData(
    String name,
    String email,
    String residentAssociationNumber,
    String apartmentId,
    bool isAdmin,
  ) async {
    return await residentCollection.document(uid).setData({
      Constants.NAME: name,
      Constants.EMAIL: email,
      Constants.RESIDENT_ASSOCIATION_ID: residentAssociationNumber,
      Constants.APARTMENT_ID: apartmentId,
      Constants.IS_ADMIN: isAdmin,
    });
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      id: uid,
      name: snapshot.data[Constants.NAME],
      email: snapshot.data[Constants.EMAIL],
      residentAssociationId: snapshot.data[Constants.RESIDENT_ASSOCIATION_ID],
      apartmentId: snapshot.data[Constants.APARTMENT_ID],
      isAdmin: snapshot.data[Constants.IS_ADMIN],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return residentCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
