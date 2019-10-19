import 'package:flutter/material.dart';

import '../../screens/notifications_screen.dart';

class NotificationNavigatorRoutes {
  static const String root = '/';
}

class NotificationNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationNavigator({this.navigatorKey});

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      NotificationNavigatorRoutes.root: (context) => NotificationScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: NotificationNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}
