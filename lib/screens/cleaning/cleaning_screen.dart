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
    return Scaffold(
      appBar: AppBar(
        title: Text("Þrif á sameign"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
    );
  }
}
