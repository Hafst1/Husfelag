import 'package:flutter/material.dart';

import './add_meeting_screen.dart';
import './meetings_list_screen.dart';
import '../../widgets/category_option.dart';
import '../../widgets/custom_icons_icons.dart';

class MeetingsScreen extends StatelessWidget {
  static const routeName = '/meetings';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Fundir"),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: heightOfBody,
        decoration: BoxDecoration(
          color: Color.fromRGBO(230, 230, 230, 1),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              CategoryOption(
                optionIcon: Icons.group_add,
                optionText: "Bóka fund",
                optionRoute: AddMeetingScreen.routeName,
              ),
              SizedBox(height: 15),
              CategoryOption(
                optionIcon: CustomIcons.find_in_page,
                optionText: "Yfirlit funda",
                optionRoute: MeetingsListScreen.routeName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
