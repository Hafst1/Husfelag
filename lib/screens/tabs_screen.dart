import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/navigators/home_navigator.dart';
import '../widgets/navigators/calendar_navigator.dart';
import '../widgets/navigators/notification_navigator.dart';
import '../services/message_handler.dart';
import '../providers/current_user_provider.dart';
import '../providers/notification_provider.dart';
import '../models/notification.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  int _notificationCounter = 0; 

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  var _isInit = true;

  void didChangeDependencies() {
    if (_isInit) {
      final currentUserData =
          Provider.of<CurrentUserProvider>(context, listen: false);
      final notificationData = Provider.of<NotificationsProvider>(context);
      final residentAssociationId = currentUserData.getResidentAssociationId();
      notificationData
          .fetchNotifications(residentAssociationId, context)
          .then((_) {
        setState(() {
          _notificationCounter = Counter.notificationCounter;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    if (_selectedPageIndex == index) {
      navigatorKeys[index].currentState.popUntil((key) => key.isFirst);
      return;
    }
    setState(() {
      _selectedPageIndex = index;
      if(_selectedPageIndex == 2) {
        Counter.notificationCounter = 0;
      }
    });
  }

  Widget _buildOffstageNavigator(Object navigator, int pageIndex) {
    return Offstage(
      offstage: _selectedPageIndex != pageIndex,
      child: navigator,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(Counter.notificationCounter != null) {
        _notificationCounter = Counter.notificationCounter;
    }
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_selectedPageIndex].currentState.maybePop(),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            MessageHandler(),
            _buildOffstageNavigator(
              HomeNavigator(navigatorKey: navigatorKeys[0]),
              0,
            ),
            _buildOffstageNavigator(
              CalendarNavigator(navigatorKey: navigatorKeys[1]),
              1,
            ),
            _buildOffstageNavigator(
              NotificationNavigator(navigatorKey: navigatorKeys[2]),
              2,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: Color.fromRGBO(255, 202, 77, 1),
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.home),
              title: Text('Heim'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.calendar_today),
              title: Text('Dagatal'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Stack(
                children: <Widget>[
                  Icon(Icons.notifications),
                  (_notificationCounter > 0) 
                  ? Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '$_notificationCounter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(height: 0, width: 0),
                ],
              ),
              title: Text('Tilkynningar'),
            ),
          ],
        ),
      ),
    );
  }
}
