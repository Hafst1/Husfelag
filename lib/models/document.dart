import 'package:flutter/material.dart';

class Document {
  final String id;
  final String title;
  final String description;
  final String fileName;
  final String downloadUrl;
  final String folderId;

  Document({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.fileName,
    @required this.downloadUrl,
    @required this.folderId,
  });
}