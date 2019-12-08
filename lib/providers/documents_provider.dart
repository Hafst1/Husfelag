import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../models/folder.dart';
import '../models/document.dart';
import '../shared/constants.dart' as Constants;

class DocumentsProvider with ChangeNotifier {
  List<Document> _documents = [];
  List<Folder> _folders = [];

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);
  // storage reference to the resident association.
  StorageReference _storageRef = FirebaseStorage.instance.ref();

  // function which fetches the documents of a resident association
  // and stores them in the _documents list.
  Future<void> fetchDocuments(
      String residentAssociationId, String folderId) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.FOLDERS_COLLECTION)
          .document(folderId)
          .collection(Constants.DOCUMENTS_COLLECTION)
          .orderBy(Constants.TITLE)
          .getDocuments();
      final List<Document> loadedDocuments = [];
      response.documents.forEach((document) {
        loadedDocuments.add(Document(
          id: document.documentID,
          title: document.data[Constants.TITLE],
          fileName: document.data[Constants.FILE_NAME],
          downloadUrl: document.data[Constants.DOWNLOAD_URL],
          folderId: document.data[Constants.FOLDER_ID],
          authorId: document.data[Constants.AUTHOR_ID],
        ));
      });
      _documents = loadedDocuments;
      notifyListeners();
    } catch (error) {}
  }

  // function which adds a file to firebase storage and obtains the downloadURL
  // for the document.
  Future<String> getDownloadUrl(String filePath, String fileName) async {
    var downloadUrl = '';
    try {
      final uploadTask = _storageRef.child(fileName).putFile(File(filePath));
      final taskSnapshot = await uploadTask.onComplete;
      downloadUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      throw (error);
    }
    return downloadUrl;
  }

  // function which adds a document to a resident association.
  Future<void> addDocument(
    String residentAssociationId,
    Document document,
  ) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.FOLDERS_COLLECTION)
          .document(document.folderId)
          .collection(Constants.DOCUMENTS_COLLECTION)
          .add({
        Constants.TITLE: document.title,
        Constants.FILE_NAME: document.fileName,
        Constants.DOWNLOAD_URL: document.downloadUrl,
        Constants.FOLDER_ID: document.folderId,
        Constants.AUTHOR_ID: document.authorId,
      });
      _documents.add(Document(
        id: response.documentID,
        title: document.title,
        fileName: document.fileName,
        downloadUrl: document.downloadUrl,
        folderId: document.folderId,
        authorId: document.authorId,
      ));
    } catch (error) {
      throw (error);
    }
  }

  // function which deletes a document from a resident association.
  Future<void> deleteDocument(
    String residentAssociationId,
    String documentId,
    String folderId,
    String fileName,
  ) async {
    final deleteIndex =
        _documents.indexWhere((document) => document.id == documentId);
    var deletedDocument = _documents[deleteIndex];
    _documents.removeAt(deleteIndex);
    notifyListeners();
    try {
      await _storageRef.child(fileName).delete();
      await _associationRef
          .document(residentAssociationId)
          .collection(Constants.FOLDERS_COLLECTION)
          .document(folderId)
          .collection(Constants.DOCUMENTS_COLLECTION)
          .document(documentId)
          .delete();
      deletedDocument = null;
    } catch (error) {
      _documents.insert(deleteIndex, deletedDocument);
      notifyListeners();
    }
  }

  // function which updates a document in a resident association.
  Future<void> updateDocument(
    String residentAssociationId,
    Document editedDocument,
    String oldFolderId,
  ) async {
    final documentIndex =
        _documents.indexWhere((document) => document.id == editedDocument.id);
    // move file from one folder to another.
    if (editedDocument.folderId != oldFolderId) {
      if (documentIndex >= 0) {
        _documents.removeAt(documentIndex);
      }
      try {
        await _associationRef
            .document(residentAssociationId)
            .collection(Constants.FOLDERS_COLLECTION)
            .document(oldFolderId)
            .collection(Constants.DOCUMENTS_COLLECTION)
            .document(editedDocument.id)
            .delete();
        await _associationRef
            .document(residentAssociationId)
            .collection(Constants.FOLDERS_COLLECTION)
            .document(editedDocument.folderId)
            .collection(Constants.DOCUMENTS_COLLECTION)
            .add({
          Constants.TITLE: editedDocument.title,
          Constants.FILE_NAME: editedDocument.fileName,
          Constants.DOWNLOAD_URL: editedDocument.downloadUrl,
          Constants.FOLDER_ID: editedDocument.folderId,
          Constants.AUTHOR_ID: editedDocument.authorId,
        });
        notifyListeners();
      } catch (error) {
        throw (error);
      }
      // update file in current folder.
    } else {
      if (documentIndex >= 0) {
        _documents[documentIndex] = editedDocument;
      }
      try {
        await _associationRef
            .document(residentAssociationId)
            .collection(Constants.FOLDERS_COLLECTION)
            .document(editedDocument.folderId)
            .collection(Constants.DOCUMENTS_COLLECTION)
            .document(editedDocument.id)
            .updateData({
          Constants.TITLE: editedDocument.title,
          Constants.FILE_NAME: editedDocument.fileName,
          Constants.DOWNLOAD_URL: editedDocument.downloadUrl,
          Constants.FOLDER_ID: editedDocument.folderId,
          Constants.AUTHOR_ID: editedDocument.authorId,
        });
        _documents.sort((a, b) => a.title.compareTo(b.title));
        notifyListeners();
      } catch (error) {
        throw (error);
      }
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
    if (query.isEmpty) {
      return documents;
    }
    documents.forEach((document) {
      if (document.title.toLowerCase().contains(searchQuery)) {
        displayList.add(document);
      }
    });
    return displayList;
  }

// function which adds a document folder to a resident association.
  Future<void> addFolder(
      String residentAssociationId, String folderTitle) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.FOLDERS_COLLECTION)
          .add({
        Constants.TITLE: folderTitle,
      });
      final newFolder = Folder(
        id: response.documentID,
        title: folderTitle,
      );
      _folders.add(newFolder);
      _folders.sort((a, b) => a.title.compareTo(b.title));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which fetches folders of a resident association and stores them
  // in the _folders list.
  Future<void> fetchFolders(String residentAssociationId) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.FOLDERS_COLLECTION)
          .orderBy(Constants.TITLE)
          .getDocuments();
      final List<Folder> loadedFolders = [];
      response.documents.forEach((folder) {
        loadedFolders.add(Folder(
          id: folder.documentID,
          title: folder.data[Constants.TITLE],
        ));
      });
      _folders = loadedFolders;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which deletes a folder and all documents within it.
  Future<void> deleteFolder(
    String residentAssociationId,
    String folderId,
  ) async {
    final deleteIndex = _folders.indexWhere((folder) => folder.id == folderId);
    var deletedFolder = _folders[deleteIndex];
    _folders.removeAt(deleteIndex);
    notifyListeners();
    try {
      [..._documents].forEach((document) async {
        await deleteDocument(
          residentAssociationId,
          document.id,
          document.folderId,
          document.fileName,
        );
      });
      await _associationRef
          .document(residentAssociationId)
          .collection(Constants.FOLDERS_COLLECTION)
          .document(folderId)
          .delete();
      deletedFolder = null;
    } catch (error) {
      _folders.insert(deleteIndex, deletedFolder);
      notifyListeners();
    }
  }

  // function which returns all folders
  List<Folder> getAllFolders() {
    return [..._folders];
  }

  // function which checks if folder title already exists
  bool folderTitleExists(String folderTitle) {
    final searchQuery = folderTitle.toLowerCase();
    bool exists = false;
    for (final folder in [..._folders]) {
      if (folder.title.toLowerCase().compareTo(searchQuery) == 0) {
        exists = true;
        break;
      }
    }
    return exists;
  }

  // function which returns a folder by it's id
  Folder findFolderById(String id) {
    return _folders.firstWhere((folder) => folder.id == id);
  }

  // function which returns the number of folders in the association
  int numberOfFolders() {
    return _folders.length;
  }
}
