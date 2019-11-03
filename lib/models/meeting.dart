import 'package:flutter/material.dart';

class Meeting {
  final String id;
  final String title;
  final DateTime date;
  final Duration duration;
  final String location;
  final String description;

  Meeting({
    @required this.id,
    @required this.title,
    @required this.date,
    @required this.duration,
    @required this.location,
    @required this.description,
  });
}
