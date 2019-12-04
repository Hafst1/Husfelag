import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:husfelagid/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference residentCollection =
      Firestore.instance.collection('user');

  Future<void> updateUserData(
    String name,
    String email,
    String residentAssociationNumber,
    String apartmentId,
    bool isAdmin,
  ) async {
    return await residentCollection.document(uid).setData({
      'name': name,
      'email': email,
      'residentAssociationId': residentAssociationNumber,
      'apartmentId': apartmentId,
      'isAdmin': isAdmin,
    });
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      id: uid,
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      residentAssociationId: snapshot.data['residentAssociationId'],
      apartmentId: snapshot.data['apartmentId'],
      isAdmin: snapshot.data['isAdmin'],
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
