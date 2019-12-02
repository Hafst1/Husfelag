import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/constructions_list_item.dart';
import '../../widgets/tab_filter_button.dart';
import '../../providers/constructions_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../shared/loading_spinner.dart';

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
              .getResidentAssociationNumber();
      Provider.of<ConstructionsProvider>(context)
          .fetchConstructions(residentAssociationId, context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshConstructions(
      String residentAssociationId, BuildContext context) async {
    await Provider.of<ConstructionsProvider>(context)
        .fetchConstructions(residentAssociationId, context);
  }

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
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final residentAssociationId =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getResidentAssociationNumber();
    final constructionData = Provider.of<ConstructionsProvider>(context);
    final constructions = constructionData.filteredItems(
      _searchQuery,
      _selectedFilterIndex,
    );
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? LoadingSpinner()
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _textFieldController,
                    onChanged: (value) => _changeSearchQuery(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        top: 25,
                        bottom: 25,
                      ),
                      hintText: "Leita...",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color:
                              _searchQuery == "" ? Colors.white : Colors.grey,
                        ),
                        onPressed: () => _onClear(),
                      ),
                    ),
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
                    child: RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      onRefresh: () =>
                          _refreshConstructions(residentAssociationId, context),
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: ListView.builder(
                          itemCount: constructions.length,
                          itemBuilder: (ctx, i) => ConstructionsListItem(
                            id: constructions[i].id,
                            title: constructions[i].title,
                            dateFrom: constructions[i].dateFrom,
                            dateTo: constructions[i].dateTo,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
