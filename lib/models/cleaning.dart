import 'package:flutter/material.dart';

class Cleaning {
  final String id;
  final String apartmentNumber;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String authorId;

  Cleaning({
    @required this.id,
    @required this.apartmentNumber,
    @required this.dateFrom,
    @required this.dateTo,
    @required this.authorId,
  });
}
