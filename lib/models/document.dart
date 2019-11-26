//import 'dart:io';
import 'dart:io';

import 'package:flutter/material.dart';

class Document {
  final String id;
  final String title;
  final String description;
  final File documentItem;
  final String folderId;

  Document({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.documentItem,
    @required this.folderId,
  });
}