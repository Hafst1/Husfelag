import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/meetings_provider.dart';
import '../../widgets/meetings_list_item.dart';
import '../../widgets/tab_filter_button.dart';

class MeetingsListScreen extends StatefulWidget {
  static const routeName = '/meetings-list';

  @override
  _MeetingsListScreenState createState() => _MeetingsListScreenState();
}

class _MeetingsListScreenState extends State<MeetingsListScreen> {
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
      title: Text("Yfirlit funda"),
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final meetingData = Provider.of<MeetingsProvider>(context);
    final meetings = meetingData.filteredItems(_searchQuery, _selectedFilterIndex);
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
                  ],
                ),
              ),
              Container(
                height: heightOfBody * 0.77,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: ListView.builder(
                  itemCount: meetings.length,
                  itemBuilder: (ctx, i) => MeetingsListItem(
                    title: meetings[i].title,
                    date: meetings[i].date,
                    location: meetings[i].location,
                    route: "some route",
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
