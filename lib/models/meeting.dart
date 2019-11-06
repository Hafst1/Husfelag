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

  Meeting.fromMap(Map snapshot,String id) :
      id = id ?? '',
      title = snapshot['title'] ?? '',
      date = DateTime.now(),
      duration = null,
      location = snapshot['location'] ?? '',
      description = snapshot['description'] ?? '';

  toJson() {
    return {
      "title": title,
      "date": date,
      "duration": duration,
      "location" : location,
      "description": description,
    };
  }

}
