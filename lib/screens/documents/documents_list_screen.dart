import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/document_item.dart';
import '../../providers/documents_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../shared/loading_spinner.dart';

class DocumentsFolderScreen extends StatefulWidget {
  final String id;

  DocumentsFolderScreen({
    this.id,
  });

  @override
  _DocumentsFolderScreenState createState() =>
      _DocumentsFolderScreenState();
}

class _DocumentsFolderScreenState extends State<DocumentsFolderScreen> {
  final _textFieldController = TextEditingController();
  String _searchQuery = '';
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getResidentAssociationId();
      Provider.of<DocumentsProvider>(context)
          .fetchDocuments(residentAssociationId, context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

   Future<void> _refreshDocuments(
      String residentAssociationId, BuildContext context) async {
    await Provider.of<DocumentsProvider>(context)
        .fetchDocuments(residentAssociationId, context);
  }

  _changeSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  _onClear() {
    setState(() {
      _searchQuery = '';
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _textFieldController.clear());
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final folder = Provider.of<DocumentsProvider>(context, listen: false)
        .findFolderById(widget.id);
    final folderName = folder.title;
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text(folderName),
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
      widget.id,
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
                              color: _searchQuery == '' ? Colors.white : Colors.grey,
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
                      color: Theme.of(context).primaryColor,
                      onRefresh: () =>
                          _refreshDocuments(residentAssociationId, context),
                        child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (ctx, i) =>Document(
                              id: documents[i].id,
                              title: documents[i].title,
                              description: documents[i].description,
                              fileName: documents[i].fileName,
                              downloadUrl: documents[i].downloadUrl,
                              folderId: documents[i].folderId,
                              isAdmin: currentUserData.isAdmin(),
                              isAuthor: documents[i].authorId ==
                                  currentUserData.getId(),
                            ),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
