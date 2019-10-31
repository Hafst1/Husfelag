import 'package:flutter/material.dart';
import 'package:husfelagid/screens/authenticate/authenticate.dart';
import 'package:husfelagid/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:husfelagid/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    // return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}