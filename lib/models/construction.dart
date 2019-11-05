import 'package:flutter/material.dart';

class Construction {
  final String id;
  final String title;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String description;

  Construction({
    @required this.id,
    @required this.title,
    @required this.dateFrom,
    @required this.dateTo,
    @required this.description,
  });

  Construction.fromMap(Map snapshot,String id) :
      id = id ?? '',
      title = snapshot['title'] ?? '',
      dateFrom = snapshot['dateFrom'] ?? '',
      dateTo = snapshot['dateTo'] ?? '',
      description = snapshot['description'] ?? '';

  toJson() {
    return {
      "title": title,
      "dateFrom": dateFrom,
      "dateTo": dateTo,
      "description": description,
    };
  }


}