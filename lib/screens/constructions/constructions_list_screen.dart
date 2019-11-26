import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/construction.dart';
import '../../widgets/constructions_list_item.dart';
import '../../widgets/tab_filter_button.dart';
import '../../providers/constructions_provider.dart';

class ConstructionsListScreen extends StatefulWidget {
  static const routeName = '/constructions-list';

  @override
  _ConstructionsListScreenState createState() =>
      _ConstructionsListScreenState();
}

class _ConstructionsListScreenState extends State<ConstructionsListScreen> {
  final _textFieldController = TextEditingController();
  int _selectedFilterIndex = 0;
  String _searchQuery = "";
  List<Construction> constructions;

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
      title: Text("Yfirlit framkvæmda"),
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final constructionData = Provider.of<ConstructionsProvider>(context);
    /* final constructions = constructionData.filteredItems(
      _searchQuery,
      _selectedFilterIndex,
    );*/
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: TabFilterButton(
                        buttonFilterId: 0,
                        buttonText: "Núverandi",
                        buttonFunc: _selectFilter,
                        buttonHeight: heightOfBody * 0.1,
                        filterIndex: _selectedFilterIndex),
                  ),
                  Expanded(
                    child: TabFilterButton(
                        buttonFilterId: 1,
                        buttonText: "Framundan",
                        buttonFunc: _selectFilter,
                        buttonHeight: heightOfBody * 0.1,
                        filterIndex: _selectedFilterIndex),
                  ),
                  Expanded(
                    child: TabFilterButton(
                        buttonFilterId: 2,
                        buttonText: "Gamalt",
                        buttonFunc: _selectFilter,
                        buttonHeight: heightOfBody * 0.1,
                        filterIndex: _selectedFilterIndex),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 5,
                ),
                child: StreamBuilder(
                    stream: constructionData.fetchProductsAsStream(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        constructions = snapshot.data.documents
                            .map((doc) =>
                                Construction.fromMap(doc.data, doc.documentID))
                            .toList();
                        return ListView.builder(
                          itemCount: constructions.length,
                          itemBuilder: (ctx, i) => ConstructionsListItem(
                            id: constructions[i].id,
                            title: constructions[i].title,
                            dateFrom: constructions[i].dateFrom,
                            dateTo: constructions[i].dateTo,
                          ),
                        );
                      } else {
                        return Text('fetching');
                      }
                    }),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

