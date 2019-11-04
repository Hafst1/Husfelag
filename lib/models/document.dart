import 'dart:io';
import 'package:flutter/material.dart';

class Document {
  final String id;
  final String title;
  final String description;
  final File document;

  Document({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.document,
  });
}