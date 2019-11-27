import 'dart:io';

import 'package:flutter/material.dart';
import '../models/document.dart';

class DocumentsProvider with ChangeNotifier {
  List<Document> _dummyData = [
    Document(
      id: "1",
      title: "Reikningur fyrir viðgerð á þaki",
      description: "",
      documentItem: File('file.txt'),
      folderId: "1",
    ),
    Document(
      id: "2",
      title: "Teikning af stigagangi",
      description: "",
      documentItem: File('file2.txt'),
      folderId: "2",
    ),
    Document(
      id: "3",
      title: "Reikningur fyrir árshátíðinni",
      description: "",
      documentItem: File('file.txt'),
      folderId: "1",
    ),
    Document(
      id: "4",
      title: "Teikning af bílageymslu",
      description: "",
      documentItem: File('file2.txt'),
      folderId: "2",
    ),
  ];

  List<Document> get items {
    return [..._dummyData];
  }
  List<Document> getAllDocuments() {
    return [..._dummyData];
  }
  /*
  List<Document> findById(String id) {
    return getAllDocuments().where((document) => document.folderId == id).toList();
  }*/
  List<Document> filteredItems(String query, String folderId) {
    List<Document> documents = [..._dummyData];
    String searchQuery = query.toLowerCase();
    List<Document> displayList = [];
    if (query.isNotEmpty) {
      documents.forEach((item) {
       if (item.title.toLowerCase().contains(searchQuery) && item.folderId == folderId) {
          displayList.add(item);
        }
      });
    }
    else {
      documents.forEach((item) {
        if(item.folderId == folderId) {
          displayList.add(item);
        }
      });
    }
    return displayList;
  }
}