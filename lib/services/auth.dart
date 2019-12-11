import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in with email and password from firebase
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      user.email;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password from firebase
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // change email function for user profile
  Future changeEmail(String email) async {
    //Create an instance of the current user.
    FirebaseUser user = await _auth.currentUser();
    try {
      await user.updateEmail(email);
    } on Exception catch (error) {
      print('email can\'t be changed' + error.toString());
      throw (error);
    }
  }

  // change password function for user profile
  Future<void> changePassword(String password) async {
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    try {
      await user.updatePassword(password);
    } on Exception catch (error) {
      print('Password can\'t be changed' + error.toString());
      throw (error);
    }
  }

  // firebase function that sends email to user for password reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
  
  // sign out function
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // delete user from authentication in firebase
  Future deleteUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    try {
      user.delete();
    } on Exception catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
