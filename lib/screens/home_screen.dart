import 'package:flutter/material.dart';

import '../services/auth.dart';
//import 'package:husfelagid/screens/settings_form.dart';
import '../screens/profile_page.dart';
import '../screens/my_association_screen.dart';
import '../widgets/home_option.dart';
import '../screens/constructions/constructions_screen.dart';
import '../screens/meetings/meetings_screen.dart';
import '../screens/documents/documents_screen.dart';
import '../screens/cleaning/cleaning_screen.dart';
import '../widgets/custom_icons_icons.dart';
import '../shared/constants.dart' as Constants;

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    void choiceAction(String choice) {
    if (choice == Constants.MY_PAGE){
      //_showSettingsPanel();
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
    } else if (choice == Constants.MY_ASSOCIATION){
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyAssociationScreen(),
          ),
        );
    } 
    else if (choice == Constants.SIGN_OUT) {
      _auth.signOut();
    }
  }

    return Scaffold(
      appBar: AppBar(
        title: Text('Húsfélagið'),
        centerTitle: true,
        // actions: <Widget>[
        //   PopupMenuButton<String>(
        //     onSelected: choiceAction,
        //     itemBuilder: (BuildContext context) {
        //       return Constants.choices.map((String choice) {
        //         return PopupMenuItem<String> (
        //           value: choice,
        //           child: Text(choice),
        //         );
        //       }).toList();
        //     }
        //   ),
        // ],
      ),
      drawer: Drawer(child: Text('The Drawer!')),
      body: GridView(
        padding: const EdgeInsets.all(25),
        children: <Widget>[
          HomeOption(
            optionIcon: CustomIcons.tools,
            optionText: 'Framkvæmdir',
            optionRoute: ConstructionsScreen.routeName,
          ),
          HomeOption(
            optionIcon: CustomIcons.group,
            optionText: 'Fundir',
            optionRoute: MeetingsScreen.routeName,
          ),
          HomeOption(
            optionIcon: CustomIcons.doc_text,
            optionText: 'Skjöl',
            optionRoute: DocumentsScreen.routeName,
          ),
          HomeOption(
            optionIcon: CustomIcons.trash,
            optionText: 'Þrif',
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