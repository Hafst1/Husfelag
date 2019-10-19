import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Húsfélagið',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.yellow,
      ),
      home: TabsScreen(),
    );
  }
}