import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:husfelagid/providers/current_user_provider.dart';
import 'package:husfelagid/screens/my_association_screen.dart';

import '../screens/profile_page.dart';
import '../services/auth.dart';

class MainDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<CurrentUserProvider>(context).getName();
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              _user,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 26,
            ),
            title: Text(
              'Mín síða',
              style: TextStyle(
                //fontFamily: '',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              size: 26,
            ),
            title: Text(
              'Mitt húsfélag',
              style: TextStyle(
                //fontFamily: '',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAssociationScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.power_settings_new,
              size: 26,
            ),
            title: Text(
              'Skrá út',
              style: TextStyle(
                //fontFamily: '',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
