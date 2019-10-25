import 'package:flutter/material.dart';

import '../../widgets/constructions_list_item.dart';
import '../../widgets/meetings_list_item.dart';
import '../../widgets/cleaning_list_item.dart';

class ConstructionsListScreen extends StatelessWidget {
  static const routeName = '/constructions-list';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yfirlit framkvæmda"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
       // height: 700,
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
          ],
        ),
      ),
    );
  }
}
