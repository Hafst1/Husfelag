import 'package:flutter/material.dart';
import '../models/document.dart';

class DocumentsProvider with ChangeNotifier {
  List<Document> _dummyData = [
    Document(
      id: "1",
      title: "Reikningur fyrir viðgerð á þaki",
      description: "",
      folderId: "2",
    ),
    Document(
      id: "2",
      title: "Teikning af stigagangi",
      description: "",
      folderId: "1",
    ),
  ];

  List<Document> get items {
    return [..._dummyData];
  }
  List<Document> filteredItems(String query, int filterIndex) {
    List<Document> documents = [..._dummyData];
    String searchQuery = query.toLowerCase();
    List<Document> displayList = [];
    if (query.isNotEmpty) {
      documents.forEach((item) {
        //if (item.title.toLowerCase().contains(searchQuery)) {
          displayList.add(item);
        //}
        });
      };
    return displayList;
  }
}