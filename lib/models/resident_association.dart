import 'package:flutter/material.dart';

class ResidentAssociation {
  final String id;
  final String name;
  final String address;
  final String accessCode;
  final String description;

  ResidentAssociation({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.accessCode,
    @required this.description,
  });
}
