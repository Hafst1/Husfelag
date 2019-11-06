import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CleaningTask {
    final String id;
    final String title;
    final String description; 


CleaningTask({
    @required this.id,
    @required this.title,
    @required this.description,
});


  CleaningTask.fromMap(Map snapshot,String id) :
      id = id ?? '',
      title = snapshot['title'] ?? '',
      description = snapshot['description'] ?? '';

  toJson() {
    return {
      "title": title,
      "description": description,
    };
  }
}