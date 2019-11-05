import 'package:flutter/material.dart';
import 'package:husfelagid/screens/constructions/constructions_list_screen.dart';

import '../../screens/home_screen.dart';
import '../../screens/constructions/constructions_screen.dart';
import '../../screens/constructions/add_construction_screen.dart';
import '../../screens/meetings/meetings_screen.dart';
import '../../screens/meetings/add_meeting_screen.dart';
import '../../screens/meetings/meetings_list_screen.dart';
import '../../screens/documents/documents_screen.dart';
import '../../screens/documents/documents_folder_screen.dart';
import '../../screens/cleaning/cleaning_screen.dart';
import '../../screens/cleaning/add_cleaning_screen.dart';
import '../../screens/cleaning/cleaning_list_screen.dart';
import '../../screens/cleaning/cleaning_tasks_screen.dart';

class HomeNavigatorRoutes {
  static const String root = '/';
  static const String constructions = ConstructionsScreen.routeName;
  static const String addConstruction = AddConstructionScreen.routeName;
  static const String constructionslist = ConstructionsListScreen.routeName;
  static const String meetings = MeetingsScreen.routeName;
  static const String addMeeting = AddMeetingScreen.routeName;
  static const String meetingsList = MeetingsListScreen.routeName;
  static const String documents = DocumentsScreen.routeName;
  static const String cleaning = CleaningScreen.routeName;
  static const String addCleaning = AddCleaningScreen.routeName;
  static const String cleaningList = CleaningListScreen.routeName;
  static const String cleaningTasks = CleaningTasksScreen.routeName;
  static const String documentFolder = DocumentsFolderScreen.routeName;
}

class HomeNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  HomeNavigator({this.navigatorKey});

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      HomeNavigatorRoutes.root: (context) => HomeScreen(),
      HomeNavigatorRoutes.constructions: (context) => ConstructionsScreen(),
      HomeNavigatorRoutes.addConstruction: (context) => AddConstructionScreen(),
      HomeNavigatorRoutes.constructionslist: (context) => ConstructionsListScreen(),
      HomeNavigatorRoutes.meetings: (context) => MeetingsScreen(),
      HomeNavigatorRoutes.addMeeting: (context) => AddMeetingScreen(),
      HomeNavigatorRoutes.meetingsList: (context) => MeetingsListScreen(),
      HomeNavigatorRoutes.documents: (context) => DocumentsScreen(),
      HomeNavigatorRoutes.cleaning: (context) => CleaningScreen(),
      HomeNavigatorRoutes.addCleaning: (context) => AddCleaningScreen(),
      HomeNavigatorRoutes.cleaningList: (context) => CleaningListScreen(),
      HomeNavigatorRoutes.cleaningTasks: (context) => CleaningTasksScreen(),
      HomeNavigatorRoutes.documentFolder: (context) => DocumentsFolderScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: HomeNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}
