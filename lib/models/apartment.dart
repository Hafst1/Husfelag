import 'package:flutter/material.dart';

class Apartment {
  final String id;
  final String apartmentNumber;
  final String accessCode;
  final List<String> residents;

  Apartment({
    @required this.id,
    @required this.apartmentNumber,
    @required this.accessCode,
    @required this.residents,
  });
}
