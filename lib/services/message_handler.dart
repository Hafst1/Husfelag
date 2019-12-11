import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../providers/constructions_provider.dart';
import '../providers/current_user_provider.dart';
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

  @override
  void initState() {
    super.initState();

    _saveDeviceToken();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {

        print('onmessage: $message');

        final snackbar = SnackBar(
          duration: const Duration(seconds: 10),
          content: Text(
            message['notification']['title'],
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.yellow[200],
        );
        Scaffold.of(context).showSnackBar(snackbar);

       residentAssociationId = message['data']['residentAssociationId'];
       switch (message['data']['type']) {
          case (Constants.ADDED_MEETING):
            {
              Provider.of<MeetingsProvider>(context)
                  .fetchMeetings(residentAssociationId);
            }
            break;
          case (Constants.ADDED_CONSTRUCTION):
            {
              Provider.of<ConstructionsProvider>(context)
                  .fetchConstructions(residentAssociationId);
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
             Provider.of<CurrentUserProvider>(context).currentUserNotifyListeners();
            }
            break;
          case (Constants.REMOVED_RESIDENT):
            {
              Provider.of<CurrentUserProvider>(context).currentUserNotifyListeners();
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
