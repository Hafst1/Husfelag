import 'package:flutter/material.dart';

class User {
  final String uid;

  User({
    @required this.uid
  });
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String residentAssociationId;
  final String apartmentId;
  final bool isAdmin;
  final String userToken;

  UserData({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.residentAssociationId,
    @required this.apartmentId,
    @required this.isAdmin,
    @required this.userToken,
  });
}
