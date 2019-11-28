import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/user.dart';
import './screens/wrapper.dart';
import './services/auth.dart';
import './providers/current_user.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: CurrentUser(),
      child: StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          title: 'Húsfélagið',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.pink[400],
          ),
          home: Wrapper(),
        ),
      ),
    );
  }
}
