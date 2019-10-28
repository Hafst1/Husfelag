import 'package:flutter/material.dart';

class Cleaning {
  final String apartment;
  final DateTime dateFrom;
  final DateTime dateTo;

  Cleaning({
    @required this.apartment,
    @required this.dateFrom,
    @required this.dateTo,
  });
}
