//import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_core/firebase_core.dart'; //þessi tvö kannski í main?
import 'package:flutter/material.dart';
import 'package:husfelagid/providers/constructions_provider.dart';
import 'package:husfelagid/providers/meetings_provider.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
//import './../providers/current_user_provider.dart';
import '../shared/constants.dart' as Constants;


//getting permission from user,
//displaying the UI when notification is recieved
class MessageHandler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription iosSubscription;
  List<String> notificationMessages;
  String residentAssociationId;

  @override
  void initState() {
  super.initState();

  _fcm.unsubscribeFromTopic('ConstructionItems');
  _fcm.subscribeToTopic('CleaningTasks');
  _saveDeviceToken();

  if (Platform.isIOS) { //þarf að biðja um leyfi ef IOs
    iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _fcm.subscribeToTopic('CleaningTasks');
    //  _saveDeviceToken();
    });

    _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      // _saveDeviceToken();
  }

  _fcm.configure(
    onMessage: (Map<String, dynamic> message) async {
    print("onMessage: $message");
    residentAssociationId = message['data']['residentAssociationId'];
    switch(message['data']['type']){
      case(Constants.ADDED_MEETING):
      {
        Provider.of<MeetingsProvider>(context).fetchMeetings(residentAssociationId);
      }
      break;
      case(Constants.ADDED_CONSTRUCTION):
      {
         Provider.of<ConstructionsProvider>(context).fetchConstructions(residentAssociationId);
      }
      break;
      case(Constants.DELETED_MEETING):
      {
        Provider.of<MeetingsProvider>(context).fetchMeetings(residentAssociationId);
      }
    }
    //gera switch case og switch(message[type] case(constants.addedconstruction) og ta gera eitthvad akvedid, )////////////////////////////////////////
    final snackbar = SnackBar(
      duration: const Duration(seconds: 10),
      content: Text(message['notification']['title'], style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.yellow[200],
      /*action: SnackBarAction(
        label: 'Fara á síðu',
        onPressed: () => null,
      ),*/
    );

    print("MESSAGESSSSS");
    print(message['notification']['title']);
    print(message['notification']['body']);
    Scaffold.of(context).showSnackBar(snackbar);
    },
  );
}
 /*
  @override
  void dispose() {
    if(iosSubscription != null) iosSubscription.cancel();
    super.didChangeDependencies();
  }
 */
  @override
  Widget build(BuildContext context) {
    //_handleMessages(context);
    return Scaffold(
    //  appBar: AppBar(
    //    backgroundColor: Colors.deepOrange,
    //    title: Text('FCM push Notifications'),
      //),
    );
  }

  // individual device notifications
  _saveDeviceToken() async {

    //ná í current user
    FirebaseUser user = await _auth.currentUser();

    //get the token for this device
    String fcmToken = await _fcm.getToken();

    if(fcmToken != null) {
      var tokenRef = _db
        .collection('Users')
        .document(user.uid);

      await tokenRef.updateData({
        'userToken' : fcmToken,
      });
    }
  }
}