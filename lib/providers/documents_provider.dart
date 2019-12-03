import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:husfelagid/models/document_folder.dart';
import '../models/document.dart';
import '../models/document_folder.dart';

class DocumentsProvider with ChangeNotifier {

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection('ResidentAssociation');

  List<Document> _documents = [];
  List<DocumentFolder> _folders = [];
  
  String downloadUrl;

  Future<void> addDocumentItem(String filePath/*, FileType _pickType*/) async{
    String fileName = filePath.split('/').last;
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageRef.putFile(File(filePath));
    await getDownloadUrl(uploadTask);
  }

  Future getDownloadUrl(StorageUploadTask uploadTask) async {
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    print("downloadUrl: " + downloadUrl);
  }

  void addDocument(String residentAssociationId, Document document) async{
    try {
      if(downloadUrl != "") {
        final response = await _associationRef
          .document(residentAssociationId)
          .collection('DocumentItems')
          .add({
          'title': document.title,
          'description': document.description,
          'documentItem': downloadUrl,
          'folderId': document.folderId
        });
        final newDocument = Document(
          id: response.documentID,
          title: document.title,
          description: document.description,
          documentItem: downloadUrl,
          folderId: document.folderId
        );
        _documents.add(newDocument);
          notifyListeners();
      }
    } catch (error) {
        throw (error);
      }
  }

  Future<void> fetchDocuments(String residentAssociationId, BuildContext context) async {
    try {
      final response =
          await _associationRef
          .document(residentAssociationId)
          .collection('DocumentItems')
          .getDocuments();
      final List<Document> loadedDocuments = [];
      response.documents.forEach((document) {
        loadedDocuments.add(Document(
          id: document.documentID,
          title: document.data['title'],
          description: document.data['description'],
          documentItem: document.data['documentItem'],
          folderId: document.data['folderId']
        ));
      });
      _documents = loadedDocuments;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp skjölum!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Halda áfram'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  List<Document> filteredItems(String query, String folderId) {
    List<Document> documents = [..._documents];
    String searchQuery = query.toLowerCase();
    List<Document> displayList = [];
    if (query.isNotEmpty) {
      documents.forEach((item) {
      if (item.title.toLowerCase().contains(searchQuery) && item.folderId == folderId 
        || item.description.toLowerCase().contains(searchQuery) && item.folderId == folderId) {
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

    void addFolder(String residentAssociationId, String folderTitle) async{
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection('Folders')
          .add({
        'title': folderTitle,
      });
      final newFolder = DocumentFolder(
        id: response.documentID,
        title: folderTitle,
      );
      _folders.add(newFolder);
        notifyListeners();
    } catch (error) {
        throw (error);
      }
  }

  Future<void> fetchFolders(String residentAssociationId, BuildContext context) async {
    try {
      final response =
          await _associationRef
          .document(residentAssociationId)
          .collection('Folders')
          .getDocuments();
      final List<DocumentFolder> loadedFolders = [];
      response.documents.forEach((document) {
        loadedFolders.add(DocumentFolder(
          id: document.documentID,
          title: document.data['title'],
        ));
      });
      _folders = loadedFolders;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp möppum!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Halda áfram'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

  }

  List<DocumentFolder> getAllFolders() {
    return [..._folders];
  }
  
  String findFolderIdByTitle(String title){
    String returnId = "";
    List<DocumentFolder> documents = [..._folders];
    for(int i = 0; i < documents.length; i++) {
      if(documents[i].title == title) {
        returnId = documents[i].id;
      }
    }
    return returnId;
  }

  DocumentFolder findFolderNameById(String id) {
    return _folders.firstWhere((folder) => folder.id == id);
  }
}