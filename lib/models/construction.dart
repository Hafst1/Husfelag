import 'package:flutter/material.dart';

class Construction {
  final String title;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String description;

  Construction({
    @required this.title,
    @required this.dateFrom,
    @required this.dateTo,
    @required this.description,
  });
}
