import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart'; //þessi tvö kannski í main?
import 'package:husfelagid/models/notification.dart';
import 'package:husfelagid/providers/notification_provider.dart';
import 'package:husfelagid/shared/loading_spinner.dart';
import 'package:husfelagid/widgets/notification_list_item.dart';
import 'package:provider/provider.dart';
import './../providers/current_user_provider.dart';

import 'dart:io';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _isInit = true;
  var _isLoading = false;

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
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
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
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                   child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          color: (i < Counter.itemCounter) ? Colors.blue[100] : Color.fromRGBO(230, 230, 230, 1),
                          child: NotificationItem(
                            id: notifications[i].id,
                            title: notifications[i].title,
                            description: notifications[i].description,
                            date: notifications[i].date,
                          ),
                        );
                      },
                    ),
                    /*child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (ctx, i) => NotificationItem(
                        id: notifications[i].id,
                        title: notifications[i].title,
                        description: notifications[i].description,
                        date: notifications[i].date,
                      ),
                  ),*/
                  ),
                ],
              ),
            ),
    );
  }
}
