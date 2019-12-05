import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/document.dart';
import '../models/document_folder.dart';

class DocumentsProvider with ChangeNotifier {
  List<Document> _documents = [];
  List<DocumentFolder> _folders = [];
  String downloadUrl; //obtain the download url for the document

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection('ResidentAssociation');

  // function which fetches the documents of a resident association
  // and stores them in the _documents list.
  Future<void> fetchDocuments(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection('DocumentItems')
          .getDocuments();
      final List<Document> loadedDocuments = [];
      response.documents.forEach((document) {
        loadedDocuments.add(Document(
          id: document.documentID,
          title: document.data['title'],
          description: document.data['description'],
          fileName: document.data['fileName'],
          downloadUrl: document.data['downloadUrl'],
          folderId: document.data['folderId']
        )); // Document
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

  // function which adds a file to firebase storage.
  Future<void> addFile(String filePath, Document document/*, FileType _pickType*/) async{
    //String fileName = filePath.split('/').last;
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(document.fileName);
    StorageUploadTask uploadTask = storageRef.putFile(File(filePath));
    await getDownloadUrl(uploadTask);
  }

  // function which obtains the downloadURL for the document.
  Future getDownloadUrl(StorageUploadTask uploadTask) async {
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  
  // function which adds a document to a resident association.
  Future<void> addDocument(
      String residentAssociationId, Document document) async{
    try {
      if(downloadUrl != "") {
        final response = await _associationRef
          .document(residentAssociationId)
          .collection('DocumentItems')
          .add({
          'title': document.title,
          'description': document.description,
          'fileName': document.fileName,
          'downloadUrl': downloadUrl,
          'folderId': document.folderId
        });
        final newDocument = Document(
          id: response.documentID,
          title: document.title,
          description: document.description,
          fileName: document.fileName,
          downloadUrl: downloadUrl,
          folderId: document.folderId
        );
        _documents.add(newDocument);
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

   // function which deletes a document from a resident association.
   // and file from storage
  Future<void> deleteDocument(
      String residentAssociationId, String documentId, String fileTitle) async {
    final deleteIndex = _documents
        .indexWhere((document) => document.id == documentId);
    var deletedDocument = _documents[deleteIndex];
    _documents.removeAt(deleteIndex);
    notifyListeners();
    try {
      StorageReference storageRef =
      FirebaseStorage.instance.ref().child(fileTitle);
      await storageRef.delete();
      await _associationRef
          .document(residentAssociationId)
          .collection('DocumentItems')
          .document(documentId)
          .delete();
      deletedDocument = null;
    } catch (error) {
      _documents.insert(deleteIndex, deletedDocument);
      notifyListeners();
    }
  }

  // function which updates a document in a resident association.
  //athuga með update!!
  Future<void> updateDocument(
      String residentAssociationId, Document editedDocument) async {
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection('DocumentItems')
          .document(editedDocument.id)
          .updateData({
        'title': editedDocument.title,
        'description': editedDocument.description,
        'fileName': editedDocument.fileName,
        'downloadUrl': downloadUrl,
        'folderId': editedDocument.folderId,
      });
      final documentIndex = _documents.indexWhere(
          (document) => document.id == editedDocument.id);
      if (documentIndex >= 0) {
        _documents[documentIndex] = editedDocument;
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which returns a document which has the id taken in as
  // parameter, if found.
  Document findDocumentById(String id) {
    return _documents.firstWhere((document) => document.id == id);
  }

  // function which returns a list of document which contain the 
  // folderId and/or search query
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
    } else {
      documents.forEach((item) {
        if(item.folderId == folderId) {
          displayList.add(item);
        }
      });
    }
    return displayList;
  }

  // function which adds a document folder to a resident association.
  Future<void> addFolder(
        String residentAssociationId, String folderTitle) async {
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

  // function which fetches the folders of a resident association
  // and stores them in the _folders list.
  Future<void> fetchFolders(
      String residentAssociationId, BuildContext context) async {
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

  // function which returns a list of document which contain the 
  // folderId and/or search query
  List<DocumentFolder> filteredFolders(String query) {
    List<DocumentFolder> folders = [..._folders];
    String searchQuery = query.toLowerCase();
    List<DocumentFolder> displayList = [];
    if (query.isNotEmpty) {
      folders.forEach((item) {
      if (item.title.toLowerCase().contains(searchQuery)) {
          displayList.add(item);
        }
      });
    } else {
      folders.forEach((item) {
          displayList.add(item);
      });
    }
    return displayList;
  }

  // function which return all folders
  List<DocumentFolder> getAllFolders() {
    return [..._folders];
  }
  
  // function which returns the id of a folder by it's title
  String findFolderIdByTitle(String title){
    String returnId = "";
    for(final folder in [..._folders]) {
      if(folder.title.compareTo(title) == 0) {
        returnId = folder.id;
        break;
      }
    }
    return returnId;
  }

  // function which checks if folder title already exists
  bool folderTitleExists(String folderTitle) {
    bool exists = false;
    for(final folder in [..._folders]) {
      if(folder.title.compareTo(folderTitle) == 0) {
        exists = true;
        break;
      }
    }
    return exists;
  }

  // function which returns a folder by its' id
  DocumentFolder findFolderById(String id) {
    return _folders.firstWhere((folder) => folder.id == id);
  }
}