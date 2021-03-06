import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/notification_provider.dart';
import './../shared/loading_spinner.dart';
import './../widgets/notification_list_item.dart';
import './../providers/current_user_provider.dart';
import '../models/notification.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _isInit = true;
  var _isLoading = false;

  // fetch the notifications to be displayed when widget is built.
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final currentUserData =
          Provider.of<CurrentUserProvider>(context, listen: false);
      final notificationData = Provider.of<NotificationsProvider>(context);
      final residentAssociationId = currentUserData.getResidentAssociationId();
      notificationData
          .fetchNotifications(residentAssociationId, context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final notificationData = Provider.of<NotificationsProvider>(context);
    final notifications = notificationData.getAllNotifications();
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Tilkynningar'),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? LoadingSpinner()
          : Container(
              height: heightOfBody,
              decoration: BoxDecoration(
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 5,
                            ),
                            elevation: 5,
                            color: (i < Counter.listItemCounter)
                                ? Color.fromRGBO(191, 212, 255, 1)
                                : Colors.white,
                            child: NotificationItem(
                              id: notifications[i].id,
                              title: notifications[i].title,
                              description: notifications[i].description,
                              date: notifications[i].date,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
