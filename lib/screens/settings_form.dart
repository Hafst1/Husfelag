import 'package:flutter/material.dart';
import 'package:husfelagid/shared/loading.dart';
import 'package:provider/provider.dart';

import 'package:husfelagid/services/database.dart';
import 'package:husfelagid/shared/constants.dart';
import 'package:husfelagid/models/user.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  String _currentName;
  String _currentEmail;
  String _currentHome;
  String _currentResId;
  String _currentApartId;
  //String _currentPassword;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Uppfærðu upplýsingarnar þínar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Nafn'),
                    validator: (val) => val.isEmpty ? 'Vinsamlegast skráðu nafn' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  /*SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.email,
                    decoration: textInputDecoration.copyWith(hintText: 'Netfang'),
                    validator: (val) => val.isEmpty ? 'Vinsamlegast skráðu netfang' : null,
                    onChanged: (val) => setState(() => _currentEmail = val),
                  ),*/
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.home,
                    decoration: textInputDecoration.copyWith(hintText: 'Heimilisfang'),
                    validator: (val) => val.isEmpty ? 'Vinsamlegast skráðu heimilisfang' : null,
                    onChanged: (val) => setState(() => _currentHome = val),
                  ),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Uppfæra',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentName ?? userData.name,
                          _currentEmail ?? userData.email,
                          _currentHome ?? userData.home,
                          _currentResId ?? userData.resId,
                          _currentApartId ?? userData.apartId
                        );
                        Navigator.pop(context);
                      }
                    }
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}