import 'package:flutter/material.dart';
import 'package:husfelagid/services/auth.dart';

import '../widgets/home_option.dart';
import '../screens/constructions/constructions_screen.dart';
import '../screens/meetings/meetings_screen.dart';
import '../screens/documents/documents_screen.dart';
import '../screens/cleaning/cleaning_screen.dart';
import '../widgets/custom_icons_icons.dart';

class HomeScreen extends StatelessWidget {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Húsfélagið'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await _auth.signOut();
            }
          )
        ],
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
