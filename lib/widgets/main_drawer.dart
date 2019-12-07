import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
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
            color: Theme.of(context).accentColor,
            child: Text(
              'Cooking up',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor,
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
              // ...
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
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
              // ...
            },
          )
        ],
      ),
    );
  }
}
