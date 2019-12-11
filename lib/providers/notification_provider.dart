import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification.dart';
import '../shared/constants.dart' as Constants;


class NotificationsProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);

    Future<void> fetchNotifications(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.NOTIFICATIONS_COLLECTION)
          .getDocuments();
      final List<NotificationModel> loadedNotifications = [];
      response.documents.forEach((notification) {
        loadedNotifications.add(NotificationModel(
          id: notification.documentID,
          title: notification.data[Constants.TITLE],
          date: DateTime.fromMillisecondsSinceEpoch(notification.data[Constants.DATE]),
          description: notification.data[Constants.DESCRIPTION],
          authorId: notification.data[Constants.AUTHOR_ID],
          type: notification.data[Constants.TYPE],
        ));
      });
      loadedNotifications.sort((b, a) => a.date.compareTo(b.date));
      // get count of new notifications
      if(Counter.prevCounter != null) {
      Counter.notificationCounter =
         loadedNotifications.length - Counter.prevCounter; 
      } else {
        Counter.notificationCounter = loadedNotifications.length;
      }
      _notifications = loadedNotifications;
      Counter.listItemCounter = Counter.notificationCounter;
      Counter.prevCounter = loadedNotifications.length;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp tilkynningum!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Halda áfram'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  List<NotificationModel> getAllNotifications() {
    return [..._notifications];
  }

   Future<void> addNotification(String residentAssociationId, NotificationModel notification) async {
      try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.NOTIFICATIONS_COLLECTION)
          .add({
        Constants.TITLE: notification.title,
        Constants.DATE: notification.date.millisecondsSinceEpoch,
        Constants.DESCRIPTION: notification.description,
        Constants.AUTHOR_ID: notification.authorId,
        Constants.TYPE: notification.type,
      });
      final newNotification = NotificationModel(
        id: response.documentID,
        title: notification.title,
        date: DateTime.now(),
        description: notification.description,
        authorId: notification.authorId,
        type: notification.type,
      );
      _notifications.add(newNotification);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

}