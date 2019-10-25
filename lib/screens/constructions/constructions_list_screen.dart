import 'package:flutter/material.dart';

import '../../widgets/constructions_list_item.dart';
import '../../widgets/meetings_list_item.dart';
import '../../widgets/cleaning_list_item.dart';

class ConstructionsListScreen extends StatefulWidget {
  static const routeName = '/constructions-list';

  @override
  _ConstructionsListScreenState createState() => _ConstructionsListScreenState();
}

class _ConstructionsListScreenState extends State<ConstructionsListScreen> {
  int _selectedFilterIndex = 0;

  _selectFilter (int index) {
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
                  Container(
                    height: heightOfBody * 0.1,
                    color: Colors.grey[300],
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 3.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            child: Text(
                              "Nýjast",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 3.0,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            child: Text(
                              "Gamalt",
                              style: TextStyle(fontSize: 18),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: heightOfBody * 0.77,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Column(
                  children: <Widget>[
                    ConstructionsListItem(
                      "Viðgerð á þaki",
                      DateTime.now(),
                      DateTime.now(),
                      "some route",
                    ),
                    MeetingsListItem(
                      "Árlegur húsfundur",
                      DateTime.now(),
                      "17:00",
                      "Egilshöll, 112 Grafarvogur",
                      "some route",
                    ),
                    CleaningListItem(
                      "104",
                      DateTime.now(),
                      DateTime.now(),
                      "some route",
                    ),
                    CleaningListItem(
                      "104",
                      DateTime.now(),
                      DateTime.now(),
                      "some route",
                    ),
                    CleaningListItem(
                      "104",
                      DateTime.now(),
                      DateTime.now(),
                      "some route",
                    ),
                    CleaningListItem(
                      "104",
                      DateTime.now(),
                      DateTime.now(),
                      "some route",
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
