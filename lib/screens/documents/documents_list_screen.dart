import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/folder.dart';

import '../../widgets/document_item.dart';
import '../../providers/documents_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../shared/loading_spinner.dart';

class DocumentsListScreen extends StatefulWidget {
  @override
  _DocumentsListScreenState createState() => _DocumentsListScreenState();
}

class _DocumentsListScreenState extends State<DocumentsListScreen> {
  final _textFieldController = TextEditingController();
  String _searchQuery = '';
  var _isInit = true;
  var _isLoading = false;
  var _folder = Folder(
    id: '',
    title: '',
  );

  // get folder which has the id passed in through arguments and fetch it's 
  // documents.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final folderId = ModalRoute.of(context).settings.arguments as String;
      if (folderId != null) {
        _folder =
            Provider.of<DocumentsProvider>(context).findFolderById(folderId);
        setState(() {
          _isLoading = true;
        });
        final residentAssociationId =
            Provider.of<CurrentUserProvider>(context, listen: false)
                .getResidentAssociationId();
        Provider.of<DocumentsProvider>(context)
            .fetchDocuments(residentAssociationId, folderId)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((_) {
          setState(() {
            _isLoading = false;
          });
          _printErrorDialog('Ekki tókst að sækja skjöl í tiltekinni möppu!');
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // function which refreshes the list of documents.
  Future<void> _refreshDocuments(
      String residentAssociationId, String folderId) async {
    if (folderId != '') {
      try {
        await Provider.of<DocumentsProvider>(context)
            .fetchDocuments(residentAssociationId, folderId);
      } catch (error) {
        await _printErrorDialog('Ekki tókst að sækja nýjustu skjöl!');
      }
    }
  }

  // function which updates the search query.
  _changeSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // function which clears the search bar.
  _onClear() {
    setState(() {
      _searchQuery = '';
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _textFieldController.clear());
    });
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
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text(_folder.title),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
    final residentAssociationId =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getResidentAssociationId();
    final documentData = Provider.of<DocumentsProvider>(context);
    final documents = documentData.filteredItems(
      _searchQuery,
      _folder.id,
    );
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? LoadingSpinner()
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                height: heightOfBody,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 10,
                      ),
                      child: TextField(
                        controller: _textFieldController,
                        onChanged: (value) => _changeSearchQuery(value),
                        decoration: InputDecoration(
                          hintText: 'Leita...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: _searchQuery == ''
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            onPressed: () => _onClear(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => _refreshDocuments(
                            residentAssociationId, _folder.id),
                        child: Container(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: ListView.builder(
                              itemCount: documents.length,
                              itemBuilder: (ctx, i) => DocumentItem(
                                id: documents[i].id,
                                title: documents[i].title,
                                fileName: documents[i].fileName,
                                downloadUrl: documents[i].downloadUrl,
                                folderId: documents[i].folderId,
                                isAdmin: currentUserData.isAdmin(),
                                isAuthor: documents[i].authorId ==
                                    currentUserData.getId(),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
