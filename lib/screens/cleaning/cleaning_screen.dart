import 'package:flutter/material.dart';

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
        title: Text("Þrif á sameign"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            CategoryOption(
              optionIcon: Icons.add,
              optionText: "Bæta við þrif",
              optionRoute: AddCleaningScreen.routeName,
              optionColor: Color(0xFFEC6086),
            ),
            SizedBox(height: 15),
            CategoryOption(
              optionIcon: Icons.find_in_page,
              optionText: "Yfirlit þrifa",
              optionRoute: CleaningListScreen.routeName,
              optionColor: Color(0xFFEC6086)
            ),
            SizedBox(height: 15),
            CategoryOption(
              optionIcon: CustomIcons.check,
              optionText: "Verkefnalisti",
              optionRoute: CleaningTasksScreen.routeName,
              optionColor: Color(0xFFEC6086)
            ),
          ],
        ),
      ),
    );
  }
}
