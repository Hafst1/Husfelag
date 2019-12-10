import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:husfelagid/models/construction.dart';
import 'package:husfelagid/models/meeting.dart';
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
        ));
      });
      loadedNotifications.sort((b, a) => a.date.compareTo(b.date));
      _notifications = loadedNotifications;
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

  Future<void> addNotificationMeeting(String residentAssociationId, Meeting meetingNotification) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.NOTIFICATIONS_COLLECTION)
          .add({
        Constants.TITLE: meetingNotification.title,
        Constants.DATE: DateTime.now().millisecondsSinceEpoch,
        Constants.DESCRIPTION: meetingNotification.description,
      });
      final newNotification = NotificationModel(
        title: meetingNotification.title,
        date: DateTime.now(),
        description: meetingNotification.description,
        id: response.documentID,
      );
      _notifications.add(newNotification);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

   Future<void> addNotificationConstruction(String residentAssociationId, Construction constructionNotification) async {
      try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.NOTIFICATIONS_COLLECTION)
          .add({
        Constants.TITLE: constructionNotification.title,
        Constants.DATE: DateTime.now().millisecondsSinceEpoch,
        Constants.DESCRIPTION: constructionNotification.description,
      });
      final newNotification = NotificationModel(
        title: constructionNotification.title,
        date: DateTime.now(),
        description: constructionNotification.description,
        id: response.documentID,
      );
      _notifications.add(newNotification);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

}