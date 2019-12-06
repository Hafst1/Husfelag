import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './models/user.dart';
import './screens/wrapper.dart';
import './services/auth.dart';
import './providers/current_user_provider.dart';
import './providers/association_provider.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: CurrentUserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AssociationsProvider(),
        ),
      ],
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
    // return ChangeNotifierProvider.value(
    //   value: CurrentUserProvider(),
    //   child: StreamProvider<User>.value(
    //     value: AuthService().user,
    //     child: MaterialApp(
    //       title: 'Húsfélagið',
    //       theme: ThemeData(
    //         primarySwatch: Colors.blue,
    //         accentColor: Colors.pink[400],
    //       ),
    //       home: Wrapper(),
    //     ),
    //   ),
    // );
  }
}
