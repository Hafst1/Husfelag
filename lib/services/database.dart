import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference 
  final CollectionReference residentCollection = Firestore.instance.collection('user');

  Future updateUserData(String name, String email, String phoneNumber, String apartmentId, String residentAssociationNumber) async {
    return await residentCollection.document(uid).setData({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'apartmentId': apartmentId,
      'residentAssociationNumber': residentAssociationNumber,
    });
  }

  // get user stream
  Stream<QuerySnapshot> get info {
    return residentCollection.snapshots();
  }
}