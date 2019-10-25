import 'package:flutter/material.dart';

import '../widgets/home_option.dart';
import '../screens/constructions/constructions_screen.dart';
import '../screens/meetings/meetings_screen.dart';
import '../screens/documents/documents_screen.dart';
import '../screens/cleaning/cleaning_screen.dart';
import '../widgets/custom_icons_icons.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Húsfélagið'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        children: <Widget>[
          HomeOption(
            optionIcon: CustomIcons.tools,
            optionText: "Framkvæmdir",
            optionRoute: ConstructionsScreen.routeName,
          ),
          HomeOption(
            optionIcon: CustomIcons.group,
            optionText: "Fundir",
            optionRoute: MeetingsScreen.routeName,
          ),
          HomeOption(
            optionIcon: CustomIcons.doc_text,
            optionText: "Skjöl",
            optionRoute: DocumentsScreen.routeName,
          ),
          HomeOption(
            optionIcon: CustomIcons.trash,
            optionText: "Þrif",
            optionRoute: CleaningScreen.routeName,
          ),
        ],
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 30,
        ),
      ),
    );
  }
}
