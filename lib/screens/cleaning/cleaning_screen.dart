import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_cleaning_screen.dart';
import './cleaning_list_screen.dart';
import './cleaning_tasks_screen.dart';
import '../../widgets/category_option.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../providers/current_user_provider.dart';

class CleaningScreen extends StatelessWidget {
  static const routeName = '/cleaning';

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<CurrentUserProvider>(context).isAdmin();
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Þrif á sameign"),
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color.fromRGBO(186, 203, 201, 1)]
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              isAdmin
                  ? CategoryOption(
                      optionIcon: Icons.add,
                      optionText: "Bæta við þrif",
                      optionRoute: AddCleaningScreen.routeName,
                    )
                  : Container(),
              isAdmin
                  ? SizedBox(
                      height: 15,
                    )
                  : Container(),
              CategoryOption(
                optionIcon: Icons.find_in_page,
                optionText: "Yfirlit þrifa",
                optionRoute: CleaningListScreen.routeName,
              ),
              SizedBox(height: 15),
              CategoryOption(
                optionIcon: CustomIcons.check,
                optionText: "Verkefnalisti",
                optionRoute: CleaningTasksScreen.routeName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
