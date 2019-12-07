import 'package:flutter/material.dart';

class CleaningTask {
    final String id;
    final String title;
    final String description; 
    final bool taskDone;

  CleaningTask({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.taskDone,
  });

}