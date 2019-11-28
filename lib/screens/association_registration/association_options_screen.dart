import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../widgets/association__option_button.dart';
import '../../screens/association_registration/create_association_screen.dart';
import '../../screens/association_registration/join_association_screen.dart';

class AssociationOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Húsfélagið'),
      actions: <Widget>[
        FlatButton.icon(
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
            })
      ],
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: mediaQuery.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            AssociationOptionButton(
              icon: Icon(
                Icons.group_add,
                size: 50,
              ),
              text: 'Stofna húsfélag',
              destScreen: CreateAssociationScreen(),
            ),
            Expanded(
              child: Container(),
            ),
            AssociationOptionButton(
              icon: Icon(
                Icons.home,
                size: 50,
              ),
              text: 'Ganga í húsfélag',
              destScreen: JoinAssociationScreen(),
            ),
            Expanded(
              child: Container(),
            ),
            SizedBox(
              height: heightOfBody * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
