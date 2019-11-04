import 'package:flutter/material.dart';
import 'package:husfelagid/models/user.dart';
import 'package:husfelagid/screens/wrapper.dart';
import 'package:husfelagid/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Húsfélagið',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.yellow,
        ),
        home: Wrapper(),
      ),
    );
  }
}
