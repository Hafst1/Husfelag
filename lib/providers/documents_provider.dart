import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/document.dart';
import '../models/document_folder.dart';
import '../shared/constants.dart' as Constants;

class DocumentsProvider with ChangeNotifier {
  List<Document> _documents = [];
  List<DocumentFolder> _folders = [];
  String downloadUrl; //obtain the download url for the document

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);

  // function which fetches the documents of a resident association
  // and stores them in the _documents list.
  Future<void> fetchDocuments(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.DOCUMENTS_COLLECTION)
          .getDocuments();
      final List<Document> loadedDocuments = [];
      response.documents.forEach((document) {
        loadedDocuments.add(Document(
          id: document.documentID,
          title: document.data[Constants.TITLE],
          description: document.data[Constants.DESCRIPTION],
          fileName: document.data[Constants.FILE_NAME],
          downloadUrl: document.data[Constants.DOWNLOAD_URL],
          folderId: document.data[Constants.FOLDER_ID],
          authorId: document.data[Constants.AUTHOR_ID],
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
   ///athuga með constants hér!!
  // function which adds a file to firebase storage.
  Future<void> addFile(String filePath, Document document) async{
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
          .collection(Constants.DOCUMENTS_COLLECTION)
          .add({
        Constants.TITLE: document.title,
        Constants.DESCRIPTION: document.description,
        Constants.FILE_NAME: document.fileName,
        Constants.DOWNLOAD_URL: downloadUrl,
        Constants.FOLDER_ID: document.folderId,
        Constants.AUTHOR_ID: document.authorId,
        });
        final newDocument = Document(
          id: response.documentID,
          title: document.title,
          description: document.description,
          fileName: document.fileName,
          downloadUrl: downloadUrl,
          folderId: document.folderId,
          authorId: document.authorId,
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
          .collection(Constants.DOCUMENTS_COLLECTION)
          .document(documentId)
          .delete();
      deletedDocument = null;
    } catch (error) {
      _documents.insert(deleteIndex, deletedDocument);
      notifyListeners();
    }
  }

  Future<void> updateFile(String filePath, Document editedDocument, String oldFileName) async {
    StorageReference storageRef =
      FirebaseStorage.instance.ref().child(oldFileName);
      try {
        await addFile(filePath, editedDocument);
        await storageRef.delete();
      } catch (error) {
        throw (error);
      }
  }

  // function which updates a document in a resident association.
  Future<void> updateDocument(
      String residentAssociationId, Document editedDocument, String editedFileName, String filePath) async {
      if(filePath != '') {
        String newFileName = filePath.split('/').last;
        if(newFileName != editedFileName) {
          print("1: " + newFileName);
          print("2: " + editedFileName);
          final response = _associationRef
            .document(residentAssociationId)
            .collection(Constants.DOCUMENTS_COLLECTION)
            .document(editedDocument.id);
          final newEditedDocument = Document(
            id: response.documentID,
            title: editedDocument.title,
            description: editedDocument.description,
            fileName: newFileName,
            downloadUrl: downloadUrl,
            folderId: editedDocument.folderId,
            authorId: editedDocument.authorId,
          );
          editedDocument = newEditedDocument;
          await updateFile(filePath, editedDocument, editedFileName);
        }
      }
    try {
      print("inni i provider: " + editedDocument.downloadUrl);
      await _associationRef
          .document(residentAssociationId)
          .collection(Constants.DOCUMENTS_COLLECTION)
          .document(editedDocument.id)
          .updateData({
        Constants.TITLE: editedDocument.title,
        Constants.DESCRIPTION: editedDocument.description,
        Constants.FILE_NAME: editedDocument.fileName,
        Constants.DOWNLOAD_URL: editedDocument.downloadUrl,
        Constants.FOLDER_ID: editedDocument.folderId,
        Constants.AUTHOR_ID: editedDocument.authorId,
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
        String residentAssociationId, String folderTitle, String authorId) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.FOLDERS_COLLECTION)
          .add({
        Constants.TITLE: folderTitle,
        Constants.AUTHOR_ID: authorId,
      });
      final newFolder = DocumentFolder(
        id: response.documentID,
        title: folderTitle,
        authorId: authorId,
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
          .collection(Constants.FOLDERS_COLLECTION)
          .getDocuments();
      final List<DocumentFolder> loadedFolders = [];
      response.documents.forEach((folder) {
        loadedFolders.add(DocumentFolder(
          id: folder.documentID,
          title: folder.data[Constants.TITLE],
          authorId: folder.data[Constants.AUTHOR_ID],
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
   // List<Document> documents = [..._documents];
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