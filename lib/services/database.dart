import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:husfelagid/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference 
  final CollectionReference residentCollection = Firestore.instance.collection('user');

  Future updateUserData(String name, String email, String home, String apartmentId, String residentAssociationNumber) async {
    return await residentCollection.document(uid).setData({
      'name': name,
      'email': email,
      'home': home,
      'apartmentId': apartmentId,
      'residentAssociationNumber': residentAssociationNumber,
    });
  }

  Future updateUserName(String name) async{
    return await residentCollection.document(uid).setData({
      'name': name,
    });
  }
   Future updateUserEmail(String email) async{
    return await residentCollection.document(uid).setData({
      'email': email,
    });
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      home: snapshot.data['home'],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return residentCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }
}