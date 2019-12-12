import 'package:husfelagid/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../providers/current_user_provider.dart';
import '../providers/constructions_provider.dart';
import '../providers/meetings_provider.dart';
import '../shared/constants.dart' as Constants;

class MessageHandler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> notificationMessages;
  String residentAssociationId;
  String userId;

  @override
  void initState() {
    super.initState();

    _saveDeviceToken();

    // Read incoming notification
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onmessage: $message');

        final snackbar = SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(
            message['notification']['title'],
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey[200],
        );
        Scaffold.of(context).showSnackBar(snackbar);

        residentAssociationId = message['data']['residentAssociationId'];
        userId = message['data']['id'];
        switch (message['data']['type']) {
          case (Constants.ADDED_MEETING):
            {
              Provider.of<MeetingsProvider>(context)
                  .fetchMeetings(residentAssociationId);
              Provider.of<NotificationsProvider>(context)
                  .fetchNotifications(residentAssociationId, context);
            }
            break;
          case (Constants.ADDED_CONSTRUCTION):
            {
              Provider.of<ConstructionsProvider>(context)
                  .fetchConstructions(residentAssociationId);
              Provider.of<NotificationsProvider>(context)
                  .fetchNotifications(residentAssociationId, context);
            }
            break;
          case (Constants.DELETED_MEETING):
            {
              Provider.of<MeetingsProvider>(context)
                  .fetchMeetings(residentAssociationId);
            }
            break;
          case (Constants.DELETED_CONSTRUCTION):
            {
              Provider.of<ConstructionsProvider>(context)
                  .fetchConstructions(residentAssociationId);
            }
            break;
          case (Constants.MADE_ADMIN):
            {
              FirebaseUser user = await _auth.currentUser();
              if (user.uid == userId) {
                Provider.of<CurrentUserProvider>(context)
                    .triggerCurrentUserRefresh();
              }
            }
            break;
          case (Constants.REMOVED_RESIDENT):
            {
              Provider.of<CurrentUserProvider>(context)
                  .triggerCurrentUserRefresh();
            }
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  // save device token for current user
  _saveDeviceToken() async {
    FirebaseUser user = await _auth.currentUser();
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokenRef = _db.collection('Users').document(user.uid);
      await tokenRef.updateData({
        'userToken': fcmToken,
      });
    }
  }
}
