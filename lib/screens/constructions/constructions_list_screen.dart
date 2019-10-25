import 'package:flutter/material.dart';

import '../../widgets/constructions_list_item.dart';
import '../../widgets/meetings_list_item.dart';
import '../../widgets/cleaning_list_item.dart';
import '../../widgets/tab_filter_button.dart';

class ConstructionsListScreen extends StatefulWidget {
  static const routeName = '/constructions-list';

  @override
  _ConstructionsListScreenState createState() =>
      _ConstructionsListScreenState();
}

class _ConstructionsListScreenState extends State<ConstructionsListScreen> {
  int _selectedFilterIndex = 0;

  _selectFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
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
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: heightOfBody,
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
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
                            buttonText: "Nýjast",
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
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ConstructionsListItem(
                      title: "Viðgerð á þaki",
                      dateFrom: DateTime.now(),
                      dateTo: DateTime.now(),
                      route: "some route",
                    ),
                    MeetingsListItem(
                      title: "Árlegur húsfundur",
                      date: DateTime.now(),
                      startsAt: "17:00",
                      location: "Egilshöll, 112 Grafarvogur",
                      route: "some route",
                    ),
                    CleaningListItem(
                      apartment: "104",
                      dateFrom: DateTime.now(),
                      dateTo: DateTime.now(),
                      route: "some route",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
