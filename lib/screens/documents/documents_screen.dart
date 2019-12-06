import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/add_document_or_folder.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/documents_provider.dart';
import '../../widgets/documents_folder_item.dart';

class DocumentsScreen extends StatefulWidget {
  static const routeName = '/documents';

  @override
  _DocumentsScreenState createState() => 
      _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final _addFolderController = TextEditingController(); 
  final _textFieldController = TextEditingController();
  String _searchQuery = "";
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
          .fetchFolders(residentAssociationId, context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

   Future<void> _refreshFolders(
      String residentAssociationId, BuildContext context) async {
    await Provider.of<DocumentsProvider>(context)
        .fetchFolders(residentAssociationId, context);
  }

  _changeSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  _onClear() {
    setState(() {
      _searchQuery = "";
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _textFieldController.clear());
    });
  }

  @override
  void dispose() {
    _addFolderController.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Skjöl"),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final residentAssociationId =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getResidentAssociationId();
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
    final folderData = Provider.of<DocumentsProvider>(context);
    final folders = folderData.filteredFolders(_searchQuery);
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
              padding: const EdgeInsets.only(
                          bottom: 5,
                ),
                height: heightOfBody,
                child: Column(
                  children: <Widget>[
                    AddOption(
                      optionIcon: Icons.add,
                      optionText: "Bæta við",
                    ),
                    Container( //her
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 10,
                      ),
                      child: TextField(
                        controller: _textFieldController,
                        onChanged: (value) => _changeSearchQuery(value),
                        decoration: InputDecoration(
                          hintText: "Leita...",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: _searchQuery == "" ? Colors.white : Colors.grey,
                            ),
                            onPressed: () => _onClear(),
                          ),
                        ),
                      ),
                    ), //her
                    Expanded(
                      child: RefreshIndicator(
                        color: Theme.of(context).primaryColor,
                        onRefresh: () => _refreshFolders(residentAssociationId, context),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.all(20),
                                itemCount: folders.length,
                                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (ctx, i) =>DocumentFolder(
                                  id: folders[i].id,
                                  title: folders[i].title,
                                  isAdmin: currentUserData.isAdmin(),
                                  isAuthor: folders[i].authorId ==
                                  currentUserData.getId(),
                                ),
                              )
                            ),
                          ],
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