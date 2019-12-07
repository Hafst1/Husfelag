import 'package:flutter/material.dart';
import 'package:husfelagid/widgets/category_option.dart';
import 'package:flutter/services.dart';

import '../widgets/main_drawer.dart';
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
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: GridView(
        padding: const EdgeInsets.all(25),
        children: <Widget>[
          HomeOption(
            optionIcon: CustomIcons.tools,
            optionText: 'Framkvæmdir',
            optionRoute: ConstructionsScreen.routeName,
            optionColor: Color(0xFFB17CF3),
          ),
          HomeOption(
            optionIcon: CustomIcons.group,
            optionText: 'Fundir',
            optionRoute: MeetingsScreen.routeName,
            optionColor: Color(0xFFF0A45E),
          ),
          HomeOption(
            optionIcon: CustomIcons.doc_text,
            optionText: 'Skjöl',
            optionRoute: DocumentsScreen.routeName,
            optionColor: Color(0xFF69E5C6),
          ),
          HomeOption(
            optionIcon: CustomIcons.trash,
            optionText: 'Þrif',
            optionRoute: CleaningScreen.routeName,
            optionColor: Color(0xFFEC6086),
          ),
        ],
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 30,
        ),
      ),
      // body: GridView(
      //   padding: const EdgeInsets.all(25),
      //   children: <Widget>[
      //     HomeOption(
      //       optionIcon: CustomIcons.tools,
      //       optionText: "Framkvæmdir",
      //       optionRoute: ConstructionsScreen.routeName,
      //       optionColor: Color(0xFFB17CF3),
      //     ),
      //     HomeOption(
      //       optionIcon: CustomIcons.group,
      //       optionText: "Fundir",
      //       optionRoute: MeetingsScreen.routeName,
      //       optionColor: Color(0xFFF0A45E),
      //     ),
      //     HomeOption(
      //       optionIcon: CustomIcons.doc_text,
      //       optionText: "Skjöl",
      //       optionRoute: DocumentsScreen.routeName,
      //       optionColor: Color(0xFF500000),
      //     ),
      //     HomeOption(
      //       optionIcon: CustomIcons.trash,
      //       optionText: "Þrif",
      //       optionRoute: CleaningScreen.routeName,
      //       optionColor: Color(0xFFEC6086),
      //     ),
      //   ],
        // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //   maxCrossAxisExtent: 300,
        //   childAspectRatio: 2 / 2,
        //   crossAxisSpacing: 20,
        //   mainAxisSpacing: 30,
        // ),
      );
    // );
  }
}
