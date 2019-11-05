import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/documents_folder_item.dart';
import '../../widgets/tab_filter_button.dart';
import '../../providers/documents_provider.dart';

class DocumentsFolderScreen extends StatefulWidget {
  static const routeName = '/document-folder';

  @override
  _DocumentsFolderScreenState createState() =>
      _DocumentsFolderScreenState();
}
class _DocumentsFolderScreenState extends State<DocumentsFolderScreen> {
  final _textFieldController = TextEditingController();
  int _selectedFilterIndex = 0;
  String _searchQuery = "";

  _selectFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
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
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Mappa"),
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final documentData = Provider.of<DocumentsProvider>(context);
    final documents = documentData.filteredItems(
      _searchQuery,
      _selectedFilterIndex,
    );
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),  
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 5,
                  ),
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (ctx, i) => DocumentListItem(
                      title: documents[i].title,
                      route: "some route",
                    ),
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
