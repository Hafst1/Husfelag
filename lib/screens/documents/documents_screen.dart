import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  static const routeName = '/documents';

    @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  TextEditingController _textFieldController = TextEditingController();
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

  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Skjöl"),
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: heightOfBody * 0.23,
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
                              color: _searchQuery == ""
                                  ? Colors.white
                                  : Colors.grey,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: (){
          
        },
      ),
      //her kemur search bar
      //svo kemur folders
      //og bæta við folder/skjali?
    );
  }
}