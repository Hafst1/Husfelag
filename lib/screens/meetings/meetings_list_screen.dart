import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/meetings_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../widgets/meetings_list_item.dart';
import '../../widgets/tab_filter_button.dart';
import '../../shared/loading_spinner.dart';

class MeetingsListScreen extends StatefulWidget {
  static const routeName = '/meetings-list';

  @override
  _MeetingsListScreenState createState() => _MeetingsListScreenState();
}

class _MeetingsListScreenState extends State<MeetingsListScreen> {
  TextEditingController _textFieldController = TextEditingController();
  int _selectedFilterIndex = 0;
  String _searchQuery = "";
  var _isInit = true;
  var _isLoading = false;

  // fetch the meetings which are to be displayed in the meetings list.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getResidentAssociationId();
      Provider.of<MeetingsProvider>(context)
          .fetchMeetings(residentAssociationId)
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

  // function which prints an error dialog.
  void _printErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text('Ekki tókst að hlaða upp fundum!'),
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

  // function which refreshes the list of meetings.
  Future<void> _refreshMeetings(
      String residentAssociationId, BuildContext context) async {
    try {
      await Provider.of<MeetingsProvider>(context)
          .fetchMeetings(residentAssociationId);
    } catch (error) {
      _printErrorDialog();
    }
  }

  // function which updates the filter index.
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

  // function which clears the search bar.
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
      title: Text("Yfirlit funda"),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
    final meetingData = Provider.of<MeetingsProvider>(context);
    final meetings =
        meetingData.filteredItems(_searchQuery, _selectedFilterIndex);
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
                            buttonText: "Framundan",
                            buttonFunc: _selectFilter,
                            buttonHeight: heightOfBody * 0.1,
                            filterIndex: _selectedFilterIndex),
                      ),
                      Expanded(
                        child: TabFilterButton(
                            buttonFilterId: 1,
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
                      onRefresh: () => _refreshMeetings(
                        currentUserData.getResidentAssociationId(),
                        context,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: ListView.builder(
                          itemCount: meetings.length,
                          itemBuilder: (ctx, i) => MeetingsListItem(
                            id: meetings[i].id,
                            title: meetings[i].title,
                            date: meetings[i].date,
                            location: meetings[i].location,
                            isAdmin: currentUserData.isAdmin(),
                            isAuthor:
                                meetings[i].authorId == currentUserData.getId(),
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
