import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tabs_screen.dart';
import './providers/constructions_provider.dart';

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
      home: ChangeNotifierProvider.value(
        value: ConstructionsProvider(),
        child: TabsScreen(),
      ),
    );
  }
}