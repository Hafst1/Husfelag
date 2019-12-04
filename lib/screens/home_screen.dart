import 'package:flutter/material.dart';

import '../services/auth.dart';
//import 'package:husfelagid/screens/settings_form.dart';
import '../screens/profile_page.dart';
import '../widgets/home_option.dart';
import '../screens/constructions/constructions_screen.dart';
import '../screens/meetings/meetings_screen.dart';
import '../screens/documents/documents_folders_screen.dart';
import '../screens/cleaning/cleaning_screen.dart';
import '../widgets/custom_icons_icons.dart';
import '../shared/constants.dart' as Constants;

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    // void _showSettingsPanel() {
    //   showModalBottomSheet(context: context, builder: (context) {
    //     return Container(
    //       padding: EdgeInsets.symmetric(vertical: 20.0, horizontal:60.0),
    //       child: SettingsForm(),
    //     );
    //   });
    // }

    void choiceAction(String choice) {
    if (choice == Constants.MyPage){
      //_showSettingsPanel();
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
          /*FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text(
              'Skrá út',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onPressed: () async {
              await _auth.signOut();
            }),
          FlatButton.icon(
            icon: Icon(Icons.settings, color: Colors.white),
            label: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onPressed: () => _showSettingsPanel(),
          )*/
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
