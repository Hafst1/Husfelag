import 'package:flutter/material.dart';

import './add_meeting_screen.dart';
import './meetings_list_screen.dart';
import '../../widgets/category_option.dart';
import '../../widgets/custom_icons_icons.dart';

class MeetingsScreen extends StatelessWidget {
  static const routeName = '/meetings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fundir"),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            CategoryOption(
              Icons.group_add,
              "Bóka fund",
              AddMeetingScreen.routeName,
            ),
            SizedBox(height: 15),
            CategoryOption(
              CustomIcons.find_in_page,
              "Yfirlit funda",
              MeetingsListScreen.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
