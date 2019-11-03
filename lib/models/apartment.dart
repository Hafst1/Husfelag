import 'package:flutter/material.dart';

class Apartment {
  final String apartmentNumber;
  final List<String> residents;

  Apartment({
    @required this.apartmentNumber,
    @required this.residents,
  });
}
