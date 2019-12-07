import 'package:flutter/material.dart';

import '../screens/profile_page.dart';
import '../services/auth.dart';

class MainDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  Widget buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          //fontFamily: '',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        //
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'FEFEFE',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
          buildListTile(
            'Mín síða', 
            Icons.person,

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ProfilePage()),
            // )
            // Navigator.of(context).pushNamed()
          ),
          buildListTile(
            'Mitt húsfélag',
            Icons.home

          ),
          buildListTile(
            'Skrá út',
            Icons.power_settings_new,
          ),
        ],
      ),
    );
  }
}
