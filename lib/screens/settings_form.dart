import 'package:flutter/material.dart';
import 'package:husfelagid/shared/constants.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  String _currentName;
  String _currentEmail;
  String _currentHome;
  String _currentPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Uppfærðu upplýsingarnar þínar',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration,
            validator: (val) => val.isEmpty ? 'Vinsamlegast skráðu nafn' : null,
            onChanged: (val) => setState(() => _currentName = val),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration,
            validator: (val) => val.isEmpty ? 'Vinsamlegast skráðu netfang' : null,
            onChanged: (val) => setState(() => _currentEmail = val),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration,
            validator: (val) => val.isEmpty ? 'Vinsamlegast skráðu heimilisfang' : null,
            onChanged: (val) => setState(() => _currentName = val),
          ),
        ],
      ),
    );
  }
}