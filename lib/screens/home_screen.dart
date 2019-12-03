import 'package:flutter/material.dart';
import 'package:husfelagid/widgets/category_option.dart';
import 'package:flutter/services.dart';

import '../services/auth.dart';
import '../screens/profile_page.dart';

import '../screens/constructions/constructions_screen.dart';
import '../screens/meetings/meetings_screen.dart';
import '../screens/documents/documents_screen.dart';
import '../screens/cleaning/cleaning_screen.dart';
import '../widgets/custom_icons_icons.dart';
import '../shared/constants.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    void choiceAction(String choice) {
    if (choice == Constants.MyPage){
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
    } else if (choice == Constants.SignOut) {
      _auth.signOut();
    }
  }

    return Scaffold(
      appBar: AppBar(
        title: Text('Húsfélagið'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String> (
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            CategoryOption(
              optionIcon: CustomIcons.tools,
              optionText: "Framkvæmdir",
              optionRoute: ConstructionsScreen.routeName,
              optionColor: Color(0xFFB17CF3),
            ),
            SizedBox(height: 15),
            CategoryOption(
              optionIcon: CustomIcons.group,
              optionText: "Fundir",
              optionRoute: MeetingsScreen.routeName,
              optionColor: Color(0xFFF0A45E),
            ),
            SizedBox(height: 15),
            CategoryOption(
              optionIcon: CustomIcons.doc_text,
              optionText: "Skjöl",
              optionRoute: DocumentsScreen.routeName,
              optionColor: Color(0xFF69E5C6),
            ),
            SizedBox(height: 15),
            CategoryOption(
              optionIcon: CustomIcons.trash,
              optionText: "Þrif",
              optionRoute: CleaningScreen.routeName,
              optionColor: Color(0xFFEC6086),
            )
          ],
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
