import 'package:flutter/material.dart';

class DocumentFolder {
  final String id;
  final String title;
  final List<String> documents;

  DocumentFolder({
    @required this.id,
    @required this.title,
    @required this.documents,
  });
}