import 'dart:io';
import 'package:flutter/material.dart';
import '../models/document.dart';
import '../models/document_folder.dart';

class DocumentsProvider with ChangeNotifier {
  List<Document> _dummyData = [
    Document(
      id: "1",
      title: "Reikningur fyrir viðgerð á þaki",
      description: "Ítarlegir reikningar frá viðgerðinni á þakinu...",
      documentItem: File('file.txt'),
      folderId: "1",
    ),
    Document(
      id: "2",
      title: "Teikning af stigagangi",
      description: "Mjög flott teikning",
      documentItem: File('file2.txt'),
      folderId: "2",
    ),
    Document(
      id: "3",
      title: "Reikningur fyrir árshátíðinni",
      description: "Takk fyrir kvöldið",
      documentItem: File('file.txt'),
      folderId: "1",
    ),
    Document(
      id: "4",
      title: "Teikning af bílageymslu",
      description: "Teikning af bílageymslu síðan 2007",
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
  void addDocument(Document document) {
    final newDocument = Document(
      id: document.id,
      title: document.title,
      description: document.description,
      documentItem: document.documentItem,
      folderId: document.folderId
    );
    _dummyData.add(newDocument);
    notifyListeners();
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
       if (item.title.toLowerCase().contains(searchQuery) || 
        item.description.toLowerCase().contains(searchQuery) && 
        item.folderId == folderId) {
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

class DocumentsFolderProvider with ChangeNotifier {
  List<DocumentFolder> _dummyData = [
    DocumentFolder(
      id: "1",
      title: "Reikningar",
    ),
    DocumentFolder(
      id: "2",
      title: "Teikningar",
    ),
  ];

  List<DocumentFolder> get items {
    return [..._dummyData];
  }

  void addFolder(String newTitle) {
    final newFolder = DocumentFolder(
      id: "3", //þetta er mjög dummy :)
      title: newTitle,
    );
    _dummyData.add(newFolder);
    notifyListeners();
  }

  List<DocumentFolder> getAllFolders() {
    return [..._dummyData];
  }
  DocumentFolder findNameById(String id) {
    return _dummyData.firstWhere((folder) => folder.id == id);
  }
}