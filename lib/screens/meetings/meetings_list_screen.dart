import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/meeting.dart';
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
  /*  final meetings =
        meetingData.filteredItems(_searchQuery, _selectedFilterIndex);*/
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
              child: TextField(
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
                    color: _searchQuery == "" ? Colors.white : Colors.grey,
                  ),
                  onPressed: () => _onClear(),
                ),
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
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 5,
                  ),
                  child: FutureBuilder<List<Meeting>>(
                          future: meetingData.fetchProducts(),
                          builder: (context, AsyncSnapshot<List<Meeting>> constructionSnapshot){
                          return (constructionSnapshot.hasData) ? 
                          ListView.builder(
                          itemCount: constructionSnapshot.data.length,
                          itemBuilder: (ctx, i) => MeetingsListItem(
                          id: constructionSnapshot.data[i].id,
                          title: constructionSnapshot.data[i].title,
                          date: constructionSnapshot.data[i].date,
                          location: constructionSnapshot.data[i].location,
                          route: "some route",
                          ),
                          ) : Container();        
                  },
                  ),
                ),
              ),
          ],
          )
        ),
      ),
    );
  }
}
