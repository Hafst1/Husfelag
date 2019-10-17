import 'package:flutter/material.dart';
import 'package:husfelagid/widgets/custom_icons_icons.dart';

import './add_cleaning_screen.dart';
import './cleaning_list_screen.dart';
import './cleaning_tasks_screen.dart';
import '../../widgets/category_option.dart';
import '../../widgets/custom_icons_icons.dart';

class CleaningScreen extends StatelessWidget {
  static const routeName = '/cleaning';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Þrif"),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            CategoryOption(
              Icons.add,
              "Bæta við þrif",
              AddCleaningScreen.routeName,
            ),
            SizedBox(height: 15),
            CategoryOption(
              Icons.find_in_page,
              "Yfirlit þrifa",
              CleaningListScreen.routeName,
            ),
            SizedBox(height: 15),
            CategoryOption(
              CustomIcons.check,
              "Verkefnalisti",
              CleaningTasksScreen.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
