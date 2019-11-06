import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cleaning {
  final String id;
  final String apartment;
  final DateTime dateFrom;
  final DateTime dateTo;

  Cleaning({
    @required this.id,
    @required this.apartment,
    @required this.dateFrom,
    @required this.dateTo,
  });

  Cleaning.fromMap(Map snapshot,String id) :
      id = id ?? '',
      apartment = snapshot['apartment'] ?? '',
      dateFrom = DateTime.now(),
      dateTo = DateTime.now();

  toJson() {
    return {
      "apartment": apartment,
      "dateFrom": dateFrom,
      "dateTo" : dateTo,
    };
  }

}
