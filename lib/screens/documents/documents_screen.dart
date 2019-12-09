import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/add_dialog.dart';
import '../../widgets/add_folder_dialog.dart';
import '../../providers/documents_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../shared/loading_spinner.dart';
import '../../widgets/folder_item.dart';
import '../../screens/documents/add_document_screen.dart';
import '../../widgets/delete_folder_dialog.dart';
import '../../models/folder.dart';

class DocumentsScreen extends StatefulWidget {
  static const routeName = '/documents';
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  var _isInit = true;
  var _isLoading = false;

  // fetch folders of the resident association.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context).getResidentAssociationId();
      Provider.of<DocumentsProvider>(context)
          .fetchFolders(residentAssociationId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((_) {
        setState(() {
          _isLoading = false;
        });
        _printErrorDialog('Ekki tókst að sækja skjöl!');
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // function which refreshes the list of folders.
  Future<void> _refreshFolders(String residentAssociationId) async {
    try {
      await Provider.of<DocumentsProvider>(context)
          .fetchFolders(residentAssociationId);
    } catch (error) {
      await _printErrorDialog('Ekki tókst að sækja nýjustu möppur!');
    }
  }

  // function which presents the dialog where user can choose to add a folder
  // or to add a file.
  void _presentAddDialog(bool atLeastOneFolder) {
    showDialog(
      context: context,
      builder: (ctx) => AddDialog(
        addFolderFunc: () {
          Navigator.of(ctx).pop();
          _presentAddFolderDialog();
        },
        addFileFunc: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddDocumentScreen(),
            ),
          );
        },
        atLeastOneFolder: atLeastOneFolder,
      ),
    );
  }

  // functions which presents a dialog where a user can create a new folder.
  void _presentAddFolderDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AddFolderDialog(
        addFunc: (folderTitle) => _addFolder(folderTitle),
      ),
    );
  }

  // function which presents the delete folder dialog.
  void _presentDeleteFolderDialog(List<Folder> folders) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteFolderDialog(
        deleteFunc: (folderId) => _presentConfirmDeleteDialog(folderId),
        folders: folders,
      ),
    );
  }

  // function which presents a dialog where user confirms the deletion of a folder.
  void _presentConfirmDeleteDialog(String folderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ertu viss um að þú viljir eyða þessari möppu?'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'HÆTTA VIÐ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text(
              'EYÐA',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteFolder(folderId);
            },
          ),
        ],
      ),
    );
  }

  // function which adds a new folder an association.
  void _addFolder(String folderTitle) async {
    final documentData = Provider.of<DocumentsProvider>(context);
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    if (documentData.folderTitleExists(folderTitle)) {
      await _printErrorDialog('Nafn á möppu er nú þegar til!');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await documentData.addFolder(
        currentUserData.getResidentAssociationId(),
        folderTitle,
      );
    } catch (error) {
      await _printErrorDialog('Ekki tókst að bæta við möppu!');
    }
    setState(() {
      _isLoading = false;
    });
  }

  // function which deletes a folder and all documents within it.
  void _deleteFolder(String folderId) async {
    final documentData = Provider.of<DocumentsProvider>(context);
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    try {
      await documentData.fetchDocuments(
        currentUserData.getResidentAssociationId(),
        folderId,
      );
      await documentData.deleteFolder(
          currentUserData.getResidentAssociationId(), folderId);
    } catch (error) {
      _printErrorDialog('Ekki tókst að eyða möppu!');
    }
  }

  // function which prints an error dialog.
  Future<void> _printErrorDialog(String errorMessage) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text(errorMessage),
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

  @override
  Widget build(BuildContext context) {
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    final documentData = Provider.of<DocumentsProvider>(context);
    final folders = documentData.getAllFolders();
    final isAdmin = currentUserData.isAdmin();
    return Scaffold(
      appBar: AppBar(
        title: Text('Skjöl'),
        centerTitle: true,
      ),
      body: _isLoading
          ? LoadingSpinner()
          : Column(
              children: <Widget>[
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refreshFolders(
                        currentUserData.getResidentAssociationId()),
                    color: Theme.of(context).primaryColor,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 20,
                        top: 20,
                        bottom: 70,
                      ),
                      itemCount: folders.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (ctx, i) => FolderItem(
                        id: folders[i].id,
                        title: folders[i].title,
                        isAdmin: currentUserData.isAdmin(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: Row(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[300],
              onPressed: () =>
                  _presentAddDialog(documentData.numberOfFolders() > 0),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: (isAdmin && documentData.numberOfFolders() > 0) ? 15 : 0,
          ),
          (isAdmin && documentData.numberOfFolders() > 0)
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey[300],
                    onPressed: () => _presentDeleteFolderDialog(folders),
                    child: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
