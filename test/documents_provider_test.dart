import 'package:flutter_test/flutter_test.dart';

import '../lib/providers/documents_provider.dart';
import '../lib/models/folder.dart';
import '../lib/models/document.dart';

final folder1 = Folder(
  id: 'folder_id_1',
  title: 'title_1',
);

final folder2 = Folder(
  id: 'folder_id_2',
  title: 'title_2',
);

final document1 = Document(
    id: 'document_id_1',
    title: 'title_1',
    fileName: 'filename_1',
    downloadUrl: 'download_url_1',
    folderId: 'folder_id_1',
    authorId: 'author_id_1');

final document2 = Document(
    id: 'document_id_2',
    title: 'title_2',
    fileName: 'filename_2',
    downloadUrl: 'download_url_2',
    folderId: 'folder_id_2',
    authorId: 'author_id_2');

void main() {
  group('folders testing:', () {
    test('should return a list of all folders', () {
      final documentsProvider = DocumentsProvider();
      documentsProvider.folders.add(folder1);
      documentsProvider.folders.add(folder2);
      expect(documentsProvider.getAllFolders(), [folder1, folder2]);
    });

    test('folder title should exist', () {
      final documentsProvider = DocumentsProvider();
      documentsProvider.folders.add(folder1);
      documentsProvider.folders.add(folder2);
      expect(documentsProvider.folderTitleExists('title_1'), true);
    });

    test('folder title should not exist', () {
      final documentsProvider = DocumentsProvider();
      documentsProvider.folders.add(folder1);
      documentsProvider.folders.add(folder2);
      expect(documentsProvider.folderTitleExists('title_49'), false);
    });

    test('should return folder by id', () {
      final documentsProvider = DocumentsProvider();
      documentsProvider.folders.add(folder2);
      expect(documentsProvider.findFolderById('folder_id_2'), folder2);
    });

    test('should return correct number of folders', () {
      final documentsProvider = DocumentsProvider();
      documentsProvider.folders.add(folder1);
      documentsProvider.folders.add(folder2);
      expect(documentsProvider.numberOfFolders(), 2);
    });
  });

  group('documents testing:', () {
    test('should return document by id', () {
      final documentsProvider = DocumentsProvider();
      documentsProvider.documents.add(document1);
      expect(documentsProvider.findDocumentById('document_id_1'), document1);
    });

    test('should return document containing query in title', () {
      final documentsProvider = DocumentsProvider();
      documentsProvider.documents.add(document1);
      documentsProvider.documents.add(document2);
      expect(documentsProvider.filteredItems('title_2'), [document2]);
    });

    test('should return empty document list', () {
      final documentsProvider = DocumentsProvider();
      documentsProvider.documents.add(document1);
      expect(documentsProvider.filteredItems('title_2'), []);
    });
  });
}
