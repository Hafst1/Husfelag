import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/cleaning_list_item.dart';
import '../../widgets/tab_filter_button.dart';
import '../../providers/cleaning_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../shared/loading_spinner.dart';

class CleaningListScreen extends StatefulWidget {
  static const routeName = '/cleaning-list';

  @override
  _CleaningListScreenState createState() => _CleaningListScreenState();
}

class _CleaningListScreenState extends State<CleaningListScreen> {
  TextEditingController _textFieldController = TextEditingController();
  int _selectedFilterIndex = 0;
  String _searchQuery = "";
  var _isInit = true;
  var _isLoading = false;

  // fetch all cleaning items which are to be displayed in the list.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getResidentAssociationId();
      Provider.of<CleaningProvider>(context)
          .fetchCleaningItems(residentAssociationId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((_) {
        setState(() {
          _isLoading = false;
        });
        _printErrorDialog();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // functions which presents an error dialog.
  void _printErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text('Ekki tókst að hlaða upp þrifum!'),
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

  // functions which refreshes and fetches the newest update of cleaning items.
  Future<void> _refreshCleaningItems(
      String residentAssociationId, BuildContext context) async {
    try {
      await Provider.of<CleaningProvider>(context)
          .fetchCleaningItems(residentAssociationId);
    } catch (error) {
      _printErrorDialog();
    }
  }

  // function which updates the selected index filter.
  _selectFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
  }

  // function which updates the search query.
  _changeSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // function which clears the text in the search bar.
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
      title: Text("Yfirlit þrifa"),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
    final cleaningData = Provider.of<CleaningProvider>(context);
    final cleanings = cleaningData.filteredItems(
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
                      onRefresh: () => _refreshCleaningItems(
                        currentUserData.getResidentAssociationId(),
                        context,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: ListView.builder(
                          itemCount: cleanings.length,
                          itemBuilder: (ctx, i) => CleaningListItem(
                            id: cleanings[i].id,
                            apartment: cleanings[i].apartmentNumber,
                            dateFrom: cleanings[i].dateFrom,
                            dateTo: cleanings[i].dateTo,
                            isAdmin: currentUserData.isAdmin(),
                            isAuthor: cleanings[i].authorId ==
                                currentUserData.getId(),
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
