import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  

  NotificationModel({
    @required this.id,
    @required this.title,
    @required this.date,
    @required this.description,
  });
}

class Counter {
  static int notificationCounter = 0;
  static int itemCounter = 0;
}
