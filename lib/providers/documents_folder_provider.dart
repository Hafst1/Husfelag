import 'package:flutter/material.dart';
import '../models/document_folder.dart';

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

  List<DocumentFolder> addFolder(String newTitle) {
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
}