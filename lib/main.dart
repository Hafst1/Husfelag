import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './models/user.dart';
import './screens/wrapper.dart';
import './services/auth.dart';
import './providers/current_user_provider.dart';
import './providers/association_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

Map<int, Color> colorMap = {
  50: Color.fromRGBO(58, 100, 124, 1),
  100: Color.fromRGBO(58, 100, 124, 0.2),
  200: Color.fromRGBO(58, 100, 124, 0.3),
  300: Color.fromRGBO(58, 100, 124, 0.4),
  400: Color.fromRGBO(58, 100, 124, 0.5),
  500: Color.fromRGBO(58, 100, 124, 0.4),
  600: Color.fromRGBO(58, 100, 124, 0.3),
  700: Color.fromRGBO(58, 100, 124, 0.2),
  800: Color.fromRGBO(58, 100, 124, 0.1),
  900: Color.fromRGBO(58, 100, 124, 1),
};

MaterialColor customColor = MaterialColor(0xFF3A647C, colorMap); 

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
            primarySwatch: customColor, 
            accentColor: Colors.pink[400],
          ),
          home: Wrapper(),
        ),
      ),
    );
  }
}
